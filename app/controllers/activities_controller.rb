class ActivitiesController < ApplicationController

  def full_description
    @item = Activity.friendly.find(params[:activity_id])
    render json:{full_description: @item.description}
  end

end