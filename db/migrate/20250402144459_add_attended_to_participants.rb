class AddAttendedToParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :participants, :attended, :boolean, default: false
  end
end
