class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants, id: :string do |t|
      t.references :event, type: :string, foreign_key: true, null: false
      t.string :phone_number, null: false
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :middle_name, null: true
      t.string :last_name, null: false
      t.string :gender, null: true
      t.date :ministry, null: true
      t.string :location, null: true
      t.timestamps

      t.index :phone_number, unique: true
      t.index :email
      t.index :first_name
      t.index :last_name
    end
  end
end
