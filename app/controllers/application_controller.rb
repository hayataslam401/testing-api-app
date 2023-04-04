class ApplicationController < ActionController::API

  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
      decoded_token = JWT.decode(token, Rails.application.credentials[:jwt_secret_key]. to_s )
      user_id = decoded_token[0]['user_id']
      @jti = decoded_token[0]['jti']
      @exp = decoded_token[0]['exp']
      if JwtDenylist.exists?(jti: @jti )
          render json: { error: 'Token has expired or revoked' }, status: :unauthorized  
      else
          @current_user = User.find_by(id: user_id) || (render json: { error: 'User not found' }, status: :unauthorized)
      end
      rescue JWT::ExpiredSignature
        render json: { error: 'Your token has expired.' }, status: :unauthorized
      end
    else
      render json: { error: 'JWT token missing' }, status: :unprocessable_entity
    end
  end
end
