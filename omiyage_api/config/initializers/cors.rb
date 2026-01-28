# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # 環境変数が設定されている場合はそれを使用、なければ環境に応じたデフォルト値を使用
    frontend_url = ENV['FRONTEND_URL']
    
    if frontend_url && !frontend_url.empty?
      # 環境変数が設定されている場合、カンマ区切りで分割
      origins frontend_url.split(',').map(&:strip)
    elsif Rails.env.production?
      # 本番環境: Vercelのオリジンを許可
      origins 'https://omiyage-roulette-psi.vercel.app'
    else
      # 開発環境・テスト環境: localhostを許可
      origins 'http://localhost:3000'
    end

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['Set-Cookie']
  end
end
