module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :require_login, only: [:create]

      # POST /api/v1/sessions
      def create
        @user = login(params[:email], params[:password])

        if @user
          render json: { user: UserBlueprint.render_as_hash(@user) }, status: :ok
        else
          render json: { errors: ['メールアドレスまたはパスワードが正しくありません'] }, status: :unauthorized
        end
      end

      # DELETE /api/v1/sessions
      def destroy
        logout
        head :no_content
      end

      # GET /api/v1/me
      def me
        render json: { user: UserBlueprint.render_as_hash(current_user) }, status: :ok
      end
    end
  end
end
