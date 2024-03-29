class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.integer :external_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postcode
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end

  def self.down
    drop_table :venues
  end
end
