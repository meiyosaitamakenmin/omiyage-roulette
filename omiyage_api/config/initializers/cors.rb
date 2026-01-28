# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # 本番環境でのデバッグログを有効化
  if Rails.env.production?
    Rails.logger.info "CORS: Initializing with FRONTEND_URL=#{ENV['FRONTEND_URL'].inspect}"
  end

  allow do
    # 許可するオリジンを明示的に設定
    allowed_origins = [
      'http://localhost:3000',
      'https://omiyage-roulette-psi.vercel.app'
    ]
    
    # 環境変数が設定されている場合は追加
    if ENV['FRONTEND_URL'].present?
      allowed_origins += ENV['FRONTEND_URL'].split(',').map(&:strip)
    end
    
    origins allowed_origins.uniq

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['Set-Cookie'],
      max_age: 86400
  end
end
