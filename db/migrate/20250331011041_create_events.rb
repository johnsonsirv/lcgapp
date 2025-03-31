class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events, id: :string do |t|
      t.string :name
      t.text :description
      t.string :theme
      t.integer :year
      t.date :start_date
      t.date :end_date
      t.string :location, null: true
      t.string :image_url, null: true
      t.integer :status, default: 0
      t.string :short_url, null: true
      t.timestamps

      t.index :year, uniqueness: true
      t.index :theme, uniqueness: true
      t.index :status
      t.index [ :start_date, :end_date ]   # For date range queries
    end
  end
end
