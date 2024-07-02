
# バインドホストと環境の指定
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { '8000' }}"
environment ENV.fetch('RAILS_ENV') { 'production' }

# スレッドの設定
threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
threads threads_count, threads_count

# ワーカーの設定
ENV.fetch('WEB_CONCURRENCY') { Etc.nprocessors * 2 }

# ワーカーのタイムアウト設定
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# アプリケーションのプリロード（Copy On Write（CoW）動作が利用され、メモリ使用量が削減）
preload_app!

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart
