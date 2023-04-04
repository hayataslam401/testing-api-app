module JsonResponse
  extend ActiveSupport::Concern

  def check_user(resource)
    if resource.user != @current_user
      render json: { error: "You are not authorized to perform this action on this #{resource.class} bcz you didn't create it." }, status: :unauthorized
    end
  end


  def unprocessable_entity_response(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end
