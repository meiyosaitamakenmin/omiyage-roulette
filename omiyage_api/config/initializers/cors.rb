# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # 複数のオリジンを許可（カンマ区切りで指定可能）
    # 環境変数が設定されていない場合は、開発環境と本番環境の両方を許可
    frontend_urls = ENV.fetch('FRONTEND_URL', 'http://localhost:3000,https://omiyage-roulette-psi.vercel.app')
    origins frontend_urls.split(',').map(&:strip)

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
