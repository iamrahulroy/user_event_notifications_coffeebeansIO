class EventsController < ApplicationController
  # Here we usually check for status and render response accordingly.
  def create
    IterableService.call(current_user, params)
    render json: { status: 200, message: 'Event created successfully!' }, status: :ok
  end
end
