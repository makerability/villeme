class Api::V1::ApiController < ActionController::Base

  respond_to :json
  before_action :ensure_json_request, :allow_params

  def allow_params
    params.permit!
  end

  def ensure_json_request  
    return if request.format == :json
    render :nothing => true, :status => 406
  end

  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

end
