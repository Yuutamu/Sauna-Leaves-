# Stripe公式 エンドポイントのサンプル：https://dashboard.stripe.com/webhooks/create?endpoint_location=local

class Customer::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token # MEMO:CSRFトークンの検証をスキップWebhookは外部からのリクエストであり、CSRFトークンを持っていないため

  def create
    playload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :endpoint_secret) # MEMO：Credentials から取得
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        playload, sig_header, endpoint_secret
      )

    # json を parse できなかったとき
    rescue JSON::ParserError => e
      p e
      status 400
      return

    # Stripe の署名が無効のとき
    rescue Stripe::SignatureVerificationError => e
      p e
      status 400
      return
    end

    # 参考（Stripe公式 Checkout で注文のフルフィルメントを実行する方法：https://stripe.com/docs/payments/checkout/fulfill-orders）
    case event.type
    when 'checkout.session.completed' # MEMO：checkout.session.completed イベントを受け取った ＝＝ Stripe による決済が正常に完了した
      session = event.data.object # MEMO：session 取得
      customer = Customer.find(session.client_reference_id)
      return unless customer # MEMO： 顧客が存在するか確認、早期リターン

      # トランザクション処理の開始
      # (トランザクション使う理由：処理の１つで例外が発生した場合に、その処理を含んだ全ての処理を巻き戻すことができるのでrollback)
      ApplicationRecord.transaction do
        order = create_order(session) # MEMO：session を元にOrder テーブルにデータ代入
        # expand に関して（Stripe公式：https://stripe.com/docs/expand）
        session_with_expand = Stripe::Checkout::Session.retrieve({ id: session.id, expand: ['line_items'] })
        session_with_expand.line_items.data.each do |line_item|
          create_order_details(order, line_item) # MEMO：retrieve で取り出したline_item をOrder_details テーブルに代入
        end
      end
      # トランザクション処理の終了

      customer.cart_items.destroy_all # MEMO：カート商品を全て削除

      # 注文確認メールの送信（参考：https://railsguides.jp/active_job_basics.html#action-mailer）
      # deliver_later メールを非同期処理
      OrderMailer.complete(email: session.customer_details.email).deliver_later

      redirect_to session.success_url
    end
  end

  private

  # Stripe Session Object 一覧（参考：https://stripe.com/docs/api/checkout/sessions/object）
  def create_order(session)
    Order.create!({
                    customer_id: session.client_reference_id,
                    name: session.shipping_details.name,
                    postal_code: session.shipping_details.address.postal_code,
                    prefecture: session.shipping_details.address.state,
                    address1: session.shipping_details.address.line1,
                    address2: session.shipping_details.address.line2,
                    postage: session.shipping_options[0].shipping_amount,
                    billing_amount: session.amount_total,
                    status: 'confirm_payment' # MEMO：'checkout.session.completed' イベントを受信した時点で、決済は完了しているのでステータスを「入金済み」へ
                  })
  end

  def create_order_details(order, line_item)
    product = Stripe::Product.retrieve(line_item.price.product)
    purchased_product = Product.find(product.metadata.product_id) # MEMO：Stripe の metadata はダッシュボードから確認可能

    raise ActiveRecord::RecordNotFound if purchased_product.nil? # MEMO：意図的に例外エラーを発生させる

    order_detail = order.order_details.create!({
                                                 product_id: purchased_product.id,
                                                 price: line_item.price.unit_amount,
                                                 quantity: line_item.quantity
                                               })
    purchased_product.update!(stock: (purchased_product.stock - order_detail.quantity)) # MEMO：購入商品の在庫数更新
  end
end
