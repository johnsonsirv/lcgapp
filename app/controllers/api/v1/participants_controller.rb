class Api::V1::ParticipantsController < ApplicationController
  include ApiResponseHelper

  before_action :set_current_event, only: [ :search ]
  before_action :set_participant, only: [ :toggle_attended ]

  def toggle_attended
    return render_success("Attendance updated successfully", {
      id: @participant.id, attended: @participant.attended
      }) if @participant.update(attended: true)

      render_error("Failed to update attendance", @participant.errors.full_messages)
  end

  def search
    query = params[:query].presence || "*"
    options = {
      where: { event_id: @event.id },
      fields: [ "phone_number^5", "first_name^10" ],
      match: :word_start,
      operator: "or",
      load: false
    }

    search_results = Participant.search(query, **options)
    puts search_results.inspect

    @participants = search_results.map do |participant|
      {
        id: participant.id,
        first_name: participant.first_name,
        last_name: participant.last_name,
        email: participant.email,
        phone_number: participant.phone_number,
        attended: participant.attended,
        event_id: participant.event_id
      }
    end

    render_success("Participants Details", @participants)
  end

  private
  def set_current_event
    @event = Event.includes(:participants).find_by(year: 2025)
  end

  def set_participant
    @participant = Participant.find(params[:id])
  end
end
