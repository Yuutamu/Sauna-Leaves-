# Content Security Policy (CSP) 設定
# クロスサイトスクリプティング (XSS) やその他のコードインジェクション攻撃から保護するために、どのソースからリソースを読み込むかを制御する HTTP ヘッダーを使用

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https
    policy.report_uri "/csp-violation-report-endpoint" # 違反レポートのURIを指定
  end

  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src style-src)

  # config.content_security_policy_report_only = true # 必要に応じて有効化
end
