class ApplicationController < ActionController::API
  include ActionController::Cookies
  before_action :require_login

  # パラメータ不足エラーのハンドリング
  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: ["パラメータが不足しています: #{exception.param}"] }, status: :bad_request
  end

  private

  # 認証が必要なエンドポイントで未認証の場合のレスポンス
  def not_authenticated
    render json: { errors: ['ログインしてください'] }, status: :unauthorized
  end
end
