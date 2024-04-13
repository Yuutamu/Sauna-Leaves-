require "active_support/core_ext/integer/time"

# MEMO:ここで指定した設定は、config/application.rb の設定よりも優先される。
Rails.application.configure do

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX likely already handle this.
  # MEMO: ”RAILS_SERVE_STATIC_FILES”にターミナルから変数代入済み（参考：https://qiita.com/aiandrox/items/408724ab8a4482fb5873）
  # config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  # MEMO：可能であれば、直接true を入れたくない
  config.public_file_server_enabled = true

  # MEMO:本番環境エラー対応のために false→true に変更
  config.assets.compile = true

  # MEMO：アセットプリコンパイルの設定を追加
  # アセットプリコンパイル時に圧縮する
  # config.assets.css_compressor = :sass # Sassは利用しない
  # config.assets.js_compressor = :uglifier # uglifierは利用しない
  # アセットのディレクトリ設定
  config.assets.digest = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # MEMO: アップロードされたファイルをローカル ファイル システムに保存
  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # MEMO: SSL設定
  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Info include generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # MEMO：Action Mailer 設定
  config.action_mailer.perform_caching = false

  # MEMO: Action Mailer 不正メールアドレスを省く機能（正常な機能を邪魔することもアリそうなので、一旦コメントアウト）
  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # 公式Doc参照:migration関連（https://railsguides.jp/configuring.html#:~:text=3.8.22%20config.active_record.dump_schema_after_migration）
  config.active_record.dump_schema_after_migration = false

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # MEMO:DNS攻撃対策の記述を変更 (Host Block されてしまうので)
  config.hosts << "localhost:10000"
  config.hosts << "sauna-leaves.onrender.com"
  config.hosts << /\.sauna-leaves\.onrender\.com\z/

  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
