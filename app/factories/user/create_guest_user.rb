module UserFactory

  extend self

  def create_guest_user(params, session)
    @params = params
    @session = session
    @user = User.new(data_for_user)
    assings_personas_to_user
    assigns_city_to_user
    assings_neighborhood_to_user
    assigns_session_to_user
    save_user
  end

  private

  def data_for_user
    {guest: true, email: "guest_#{Time.now.to_i}#{rand(100)}@example.com"}
  end

  def assings_personas_to_user
    @user.personas << Persona.first
  end

  def assigns_city_to_user
    @user.city = @params[:city].blank? ? City.where(launch: true).first : City.friendly.find(@params[:city])
  end

  def assings_neighborhood_to_user
    @user.neighborhood_name = @user.city.try(:neighborhoods).try(:first).try(:name)
  end

  def assigns_session_to_user
    @session[:guest_user_id] = @user.id
  end

  def save_user
    if @user.save
      @user
    else
      false
    end
  end

end
