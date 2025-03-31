module ApiResponseHelper
  extend ActiveSupport::Concerns
  def render_success(message, data = {})
  render json: {
    status: {
      code: 200,
      message: message
    },
      data: data
    }
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end
