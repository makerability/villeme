class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  

  def facebook

  	# render :text => "<pre>" + env["omniauth.auth"].to_yaml and return
  	
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
    auth = request.env["omniauth.auth"]

    if @user.persisted?
      @user.update_attributes(token: auth["credentials"]["token"])
      sign_in_and_redirect @user, :events => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end


end