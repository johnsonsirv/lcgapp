class Api::V1::ParticipantsController < ApplicationController
  before_action :set_current_event, only: [ :search ]

  def search
    render json: {}
  end

  private
  def set_current_event
    @event = Event.find_by(year: "2025").first
  end
end
