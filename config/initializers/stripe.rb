# MEMO：サーバを起動した際に Credentials に設定した Stripe のキーを読み込む必要がある
Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

# MEMO: Stripe-API のversion を常に新しいものにしておく必要がある（参照：https://docs.stripe.com/api/versioning?lang=ruby）
Stripe.api_version = '2023-10-16'
