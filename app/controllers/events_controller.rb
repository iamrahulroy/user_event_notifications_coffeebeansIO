class EventsController < ApplicationController
  # Here we usually check for status and render response accordingly.
  def create
    response = IterableService.call(current_user, params)

    if response&.code&.to_i == 200
      flash[:success] = "Event Created successfully created!"
    else
      flash[:error] = "Failure creating event!"
    end

    redirect_back fallback_location: root_path
  end
end
