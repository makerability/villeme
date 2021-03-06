class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # access only logged users
  before_action :is_logged, only: [:new, :edit, :create, :update]

  # access only for admin users
  before_action :is_admin, only: [:index, :destroy]

  layout 'fullwidth_layout'

  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1
  # GET /places/1.json
  def show
    @title = "Eventos e atividade acontecendo em #{@place.name}"
    @items = Item.items_to_json(@place.items, user: current_or_guest_user).as_json
  end

  # GET /places/new
  def new
    @place = current_user.items.new

    gon.latitude = @place.latitude.blank? ? current_user.city.latitude : @place.latitude
    gon.longitude = @place.longitude.blank? ? current_user.city.longitude : @place.longitude

  end

  # GET /places/1/edit
  def edit

    if current_user == @place.user or current_user.admin?
      gon.latitude = @place.latitude.blank? ? current_user.city.latitude : @place.latitude
      gon.longitude = @place.longitude.blank? ? current_user.city.longitude : @place.longitude
    else
      redirect_to root_path, alert: 'You do not have permission to edit this place.'
    end

  end

  # POST /places
  # POST /places.json
  def create

    # Cria o lugar com os parametros enviados pelo formulario
    @place = current_user.items.new(place_params)

    # Busca o 'id' do bairro selecionado no mapa
    @neighborhood = Neighborhood.find_by(name: place_params[:neighborhood])


    unless @neighborhood.blank?
      @place.neighborhood = @neighborhood
    end

    # Salva o lugar 
    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render action: 'show', status: :created, location: @place }
      else
        format.html { render action: 'new' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update


    # Busca o bairro selecionado no mapa
    @neighborhood = Neighborhood.find_by(name: place_params[:neighborhood])


    unless @neighborhood.blank?
      @place.neighborhood = @neighborhood
    end

    
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Lugar cadastrado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:name, :description, :neighborhood, :latitude, :longitude, :address, :full_address, :number, :category_ids => [])
    end
end
