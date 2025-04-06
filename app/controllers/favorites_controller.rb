class FavoritesController < ApplicationController
    before_action :set_user
  
    def index
      favorites = @user.favorite_products
      render json: favorites
    end
  
    def create
      favorite = @user.favorites.build(product_id: params[:product_id])
  
      if favorite.save
        render json: favorite, status: :created
      else
        render json: { errors: favorite.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      favorite = @user.favorites.find_by(product_id: params[:product_id])
      
      if favorite
        favorite.destroy
        head :no_content
      else
        render json: { error: 'Favorite not found' }, status: :not_found
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
    end
  end
  