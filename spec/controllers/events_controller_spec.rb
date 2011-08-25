require 'spec_helper'

describe EventsController do

  describe "GET 'nearby'" do
    it "should be successful" do
      get 'nearby'
      response.should be_success
    end
  end

end
