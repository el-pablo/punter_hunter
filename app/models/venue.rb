class Venue < ActiveRecord::Base

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_many :events

  def self.add_if_not_exists(name, external_id, address1, address2, city, postcode, latitude, longitude)
    if(Venue.where(:external_id => external_id).count > 0) then
      return false, Venue.where(:external_id => external_id).first
    end

    venue = Venue.create!(:name => name, 
                  :external_id => external_id, 
                  :address1 => address1, 
                  :address2 => address2, 
                  :city => city, 
                  :postcode => postcode, 
                  :longitude => longitude, 
                  :latitude => latitude)

    return true, venue
  end

end
