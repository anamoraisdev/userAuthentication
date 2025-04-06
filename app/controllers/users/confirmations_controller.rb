# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    user = User.find_by_confirmation_token(params[:confirmation_token])
    
    if user.present? && user.confirmed_at.nil?
      user.confirm
      redirect_to "http://localhost:3000/users/confirmation"
    else
      render json: { error: "Invalid or already confirmed token" }, status: :unprocessable_entity
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
