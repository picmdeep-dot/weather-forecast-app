class CreateForecastDays < ActiveRecord::Migration[8.0]
  def change
    create_table :forecast_days do |t|
      t.references :location, null: false, foreign_key: true
      t.date :date
      t.float :high_f
      t.float :low_f
      t.string :summary

      t.timestamps
    end
  end
end
