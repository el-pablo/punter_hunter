namespace :punterhunter  do
  desc "Import events and venues for all bullseye genres"
  task :import => :environment do
    Event.delete_past_events
    Event.import_from_bullseye
  end
end
