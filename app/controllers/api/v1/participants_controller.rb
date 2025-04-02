class Api::V1::ParticipantsController < ApplicationController
  include ApiResponseHelper

  before_action :set_current_event, only: [ :search ]

  def search
    query = params[:query].presence || "*"
    options = {
      where: { event_id: @event.id },
      fields: ["phone_number^10", "first_name^5"],
      match: :word_start,
      operator: "or",
      load: false
    }

    search_results = Participant.search(query, **options)

    @participants = search_results.map do |participant|
      {
        id: participant.id,
        first_name: participant.first_name,
        last_name: participant.last_name,
        email: participant.email,
        phone_number: participant.phone_number,
        event_id: participant.event_id
      }
    end

    render_success("Participants Details", @participants)
  end

  private
  def set_current_event
    @event = Event.includes(:participants).find_by(year: 2025)
  end
end
