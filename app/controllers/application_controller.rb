class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end
