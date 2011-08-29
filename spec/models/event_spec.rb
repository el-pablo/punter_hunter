require 'spec_helper'
require 'fakeweb'

describe Event do
  it "should create a new event if the event has not been added before" do
    Event.find(:all).count.should == 0
    added, event = Event.add_if_not_exists("test", Time.now+6000,42,Venue.new)
    Event.find(:all).count.should == 1
    added.should be_true
    event.external_id.should == 42
  end

  it "should not create a new event if the event has been added before" do
    Event.create!(:name=>"pre-test", :external_id=>42)
    Event.find(:all).count.should == 1
    added, event = Event.add_if_not_exists("test", Time.now+6000, 42, Venue.new)
    added.should be_false
    event.external_id.should == 42
  end

  it "should import all events from all genres from bullseye" do
    register_bullseye_event_urls_with_fakeweb(6,3)
    Event.import_from_bullseye
    Event.find(:all).count.should == 923
  end

  it "should import all venues once only from bullseye" do
    register_bullseye_event_urls_with_fakeweb(6,3)
    Event.import_from_bullseye
    venues = Venue.find(:all)
    venues.count.should be < 920
    venues.count.should be > 10
  end

  it "should remove entries with an end date in the past" do
    Event.create(:name => "future end date 1", :end_time => Time.now+6000)
    Event.create(:name => "future end date 2", :end_time => Time.now+12000)
    Event.create(:name => "passed end date 1", :end_time => Time.now-3000)
    Event.delete_past_events
    Event.count.should == 2
  end

  def register_bullseye_event_urls_with_fakeweb(no_genres,no_pages)
    FakeWeb.allow_net_connect = false
    no_genres.times do |genre_id|
      no_pages.times do |page_no|
        url = "http://api.bullseyehub.com/v2/genres/#{genre_id+1}/events.xml?api_key=4f0ea53a65742b98&page=#{page_no+1}";
        file_location = "./spec/models/events_xml/events_genre_#{genre_id+1}_page_#{page_no+1}.xml"
        if(File.exists?(file_location)) then
          response_file = File.open("./spec/models/events_xml/events_genre_#{genre_id+1}_page_#{page_no+1}.xml","rb")
          FakeWeb.register_uri(:get, url, :body => response_file.read)
        end
      end
    end
  end
end
