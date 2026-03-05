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
    query = params[:query]&.strip

    if query.blank? || query.length < 2
      return render_success("Participants Details", [])
    end

    @participants = Participant
      .smart_search(query)
      .select(:id, :first_name, :last_name, :email, :phone_number, :attended, :event_id)
      .limit(50)

    render_success("Participants Details", @participants)
  end

  private

  def set_current_event
    @event = Event.includes(:participants).find_by(year: 2026)
  end

  def set_participant
    @participant = Participant.find(params[:id])
  end
end
