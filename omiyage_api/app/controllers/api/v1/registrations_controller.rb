module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :require_login

      # POST /api/v1/registrations
      def create
        @user = User.new(user_params)

        if @user.save
          auto_login(@user)
          render json: { user: UserBlueprint.render_as_hash(@user) }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
