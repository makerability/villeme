# encoding: utf-8
class EventsController < ApplicationController

  def full_description
    @item = Event.friendly.find(params[:event_id])
    render json:{full_description: @item.description}
  end

end
