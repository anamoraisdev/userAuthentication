class TokensController < ApplicationController
    before_action :authenticate_user!
  
    # GET /me
    def me
      return render json: current_user, status: :ok
    end
  end