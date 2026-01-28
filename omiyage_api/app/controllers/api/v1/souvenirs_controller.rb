module Api
  module V1
    class SouvenirsController < ApplicationController
      before_action :set_souvenir, only: [:show, :update, :destroy]
      before_action :authorize_owner!, only: [:update, :destroy]

      # GET /api/v1/souvenirs
      def index
        @souvenirs = current_user.souvenirs
                                 .by_category(params[:category])

        @souvenirs = @souvenirs.within_budget(params[:max_price]) if params[:max_price].present?
        @souvenirs = @souvenirs.order(created_at: :desc)

        render json: { souvenirs: SouvenirBlueprint.render_as_hash(@souvenirs) }
      end

      # GET /api/v1/souvenirs/:id
      def show
        render json: { souvenir: SouvenirBlueprint.render_as_hash(@souvenir) }
      end

      # POST /api/v1/souvenirs
      def create
        @souvenir = current_user.souvenirs.build(souvenir_params)

        if @souvenir.save
          render json: { souvenir: SouvenirBlueprint.render_as_hash(@souvenir) }, status: :created
        else
          render json: { errors: @souvenir.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/souvenirs/:id
      def update
        if @souvenir.update(souvenir_params)
          render json: { souvenir: SouvenirBlueprint.render_as_hash(@souvenir) }
        else
          render json: { errors: @souvenir.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/souvenirs/:id
      def destroy
        @souvenir.destroy
        render json: { message: '削除しました' }
      end

      # GET /api/v1/souvenirs/random
      def random
        souvenirs = current_user.souvenirs
                                .within_budget(params[:budget])
                                .by_category(params[:category])

        selected = souvenirs.order('RANDOM()').first

        if selected
          render json: { souvenir: SouvenirBlueprint.render_as_hash(selected) }
        else
          render json: {
            souvenir: nil,
            message: '条件に合うお土産が見つかりませんでした'
          }
        end
      end

      private

      def set_souvenir
        @souvenir = current_user.souvenirs.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['お土産が見つかりません'] }, status: :not_found
      end

      def authorize_owner!
        unless @souvenir.user_id == current_user.id
          render json: { errors: ['権限がありません'] }, status: :forbidden
        end
      end

      def souvenir_params
        params.require(:souvenir).permit(:name, :price, :category, :description, :image_url)
      end
    end
  end
end
