require 'nokogiri'
require 'open-uri'

class Event < ActiveRecord::Base

  belongs_to :venue

  def self.add_if_not_exists(name, end_time, external_id,venue)
    if(Event.where(:external_id => external_id).count > 0) then
      return false, Event.where(:external_id => external_id).first
    end
    event = Event.create!(:name=>name, :end_time=>end_time, :external_id=>external_id, :venue=> venue)
    return true,event
  end

  def self.delete_past_events()
    Event.delete_all(["end_time < ?",Time.now])
  end

  def self.import_from_bullseye
    6.times do |genre_id|
      events_imported = -1
      page_id = 1
      while(events_imported != 0) do
        events_imported = 0
        doc = Nokogiri::XML(open(get_bullseye_url(genre_id+1, page_id)))
        doc.xpath('//events/event').each  do |event_node|
          venue_added, venue = Venue.add_if_not_exists(event_node.xpath("./venue/name").text,
                                                 event_node.xpath("./venue/id").text.to_i,
                                                 event_node.xpath("./venue/street").text,
                                                 event_node.xpath("./venue/area").text,
                                                 event_node.xpath("./venue/city").text,
                                                 event_node.xpath("./venue/postcode").text,
                                                 event_node.xpath("./venue/location/latitude").text.to_f,
                                                 event_node.xpath("./venue/location/longitude").text.to_f)
          
          event_added, event = Event.add_if_not_exists(event_node.xpath("./name").text,
                                          Time.parse(event_node.xpath("./end_time").text),
                                          event_node.xpath("./id").text.to_i,
                                          venue)
          
          if(event_added) then
            if(events_imported == -1) then events_imported = 1
            else events_imported += 1 end
          end
        end
        puts "Added #{events_imported} events for genre #{genre_id+1} and page #{page_id}"
        page_id += 1
      end
    end
  end

  def to_xml(options={})
    options.merge!(:include => :venue)
    super(options)
  end


  def self.get_bullseye_url(genre_no, page_no)
    url = "http://api.bullseyehub.com/v2/genres/#{genre_no}/events.xml?api_key=4f0ea53a65742b98&page=#{page_no}"
    puts "Getting: #{url}"
    return url
  end

end
