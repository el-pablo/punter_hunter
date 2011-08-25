World(Rack::Test::Methods)

Given /^I send and accept XML$/ do
  header 'Accept', 'text/xml'
  header 'Content-Type', 'text/xml'
end

Given /^I have imported (\d+) events near the Soho Theatre$/ do |no_events|
  no_events_int = no_events.to_i
  (1..no_events.to_i).each { |i|
    venue = Venue.create!(:name => "test_venue"+i.to_s, :latitude => 51.515172, :longitude => -0.132737)
    Event.create!(:name => "test_event"+i.to_s, :venue => venue, :end_time => Time.now+500)
  }
end

Given /^I have imported 1 event more than (\d+) kilometres away from the Soho Theatre$/ do |distance|
  venue = Venue.create!(:name => "out_of_range_venue", :latitude => 51.465444, :longitude => -0.013046)
  Event.create!(:name => "out_of_range_event", :venue => venue, :end_time => Time.now+500)
end

Given /^I have imported (\d+) events near the Soho Theatre that finish in (\d+) minutes$/ do |no_events, time_til_finish|
  (1..no_events.to_i).each {|i|
    venue = Venue.create!(:name => "test_venue"+i.to_s, :latitude => 51.515172, :longitude => -0.132737)
    Event.create!(:name => "test_event"+i.to_s, :venue => venue, :end_time => (Time.now + 60*time_til_finish.to_i))
  }
end

When /I send a GET request for "([^\"]*)"$/ do |path|
  get path
end

Then /^the response should be an array with (\d+) "([^"]*)" elements$/ do |no_elements, element_name|
  doc = Nokogiri::Slop(last_response.body)
  doc.events.event.size.should == no_elements.to_i
end
