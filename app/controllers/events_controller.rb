class EventsController < ApplicationController
  def nearby
    puts Time.now
    venues = Venue.within(params[:distance], :origin => [params[:latitude],params[:longitude]])
    @events = Event.where("venue_id in (?) AND end_time > ? AND end_time < ?", venues, Time.now, get_end_time_limit(params))
    render :xml => @events
  end

  def all
    @all_events = Event.find(:all)
    render :xml => @all_events
  end

  def get_end_time_limit(params)
    end_time_limit = Time.new(2200,01,01,01,00)
    time_limit_param = params[:time_limit]
    if(!time_limit_param.nil? && !time_limit_param.empty?) then
      end_time_limit = Time.now+(60*(params[:time_limit].to_i))
    end
    return end_time_limit
  end
end
