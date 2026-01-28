class ApplicationController < ActionController::API
  include ActionController::Cookies
  before_action :require_login

  private

  # 認証が必要なエンドポイントで未認証の場合のレスポンス
  def not_authenticated
    render json: { errors: ['ログインしてください'] }, status: :unauthorized
  end
end
