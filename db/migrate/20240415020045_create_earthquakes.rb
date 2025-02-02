class CreateEarthquakes < ActiveRecord::Migration[7.1]
  def change
    create_table :earthquakes do |t|
      t.string :external_id
      t.decimal :magnitude
      t.string :place
      t.datetime :time
      t.boolean :tsunami
      t.string :mag_type
      t.string :title
      t.decimal :longitude
      t.decimal :latitude
      t.string :external_url

      t.timestamps
    end
  end
end
