# frozen_string_literal: true
require 'jwt'
class Api::V1::Users::SessionsController < Devise::SessionsController
  # include ActionController::MimeResponds
    # before_action :configure_sign_in_params, only: [:create]
    before_action :authorize_request, only: [:destroy]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    def create
      user = User.find_by(email: params[:email])
      if user&.valid_password?(params[:password])
        token = JsonWebToken.createjwt(user)
        render json: { token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
      #super
    end

    def destroy 
        if @current_user
          JwtDenylist.create(jti: @jti, exp: Time.zone.at(@exp))
          sign_out(@current_user)
          render json: { message: 'Successfully logged out' }, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
    end

    protected
    def respond_to(*args)
      if args.last.is_a?(Hash) && args.last.key?(:location)
        args.last[:status] ||= :found
      end
    end
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
end