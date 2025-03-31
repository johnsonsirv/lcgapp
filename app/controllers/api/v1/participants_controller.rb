class Api::V1::ParticipantsController < ApplicationController
  include ApiResponseHelper

  before_action :set_current_event, only: [ :search ]

  def search
    render_success("Participants", [ {} ])
  end

  private
  def set_current_event
    @event = Event.includes(:participants).find_by(year: 2025).first
  end
end
