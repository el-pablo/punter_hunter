class EventsController < ApplicationController
  def nearby
    end_time_limit = Time.new(2200,01,01,01,00)
    time_limit_param = params[:time_limit]
    if(!time_limit_param.nil? && !time_limit_param.empty?) then
      end_time_limit = Time.now+(60*(params[:time_limit].to_i))
    end
    venues = Venue.within(5, :origin => [params[:latitude],params[:longitude]])
    @events = Event.where("venue_id in (?) AND end_time > ? AND end_time < ?", venues.map{|venue|venue.id}, Time.now, end_time_limit)
    render :xml => @events
  end

end
