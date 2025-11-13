class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :ip_address
      t.string :street_address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
