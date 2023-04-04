require 'jwt'
class JsonWebToken
  class << self
    def createjwt(user)
      payload = { user_id: user.id ,
      exp: (Time.now + 1.day).to_i ,
      jti: SecureRandom.uuid 
      } 
      JWT.encode(payload, Rails.application.credentials[:jwt_secret_key]. to_s )
    end
  end
end