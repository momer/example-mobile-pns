require 'gcm'

class AndroidAlertWorker
  include Sidekiq::Worker
  include Sidekiq::Schedulable

  # Sidetiq should schedule this job every day, Monday-Friday, at 08:30
  # Note: The job will be queued at this time, not executed.
  recurrence do 
    weekly(1).
      day(:monday, :tuesday, :wednesday, :thursday, :friday).
      hour_of_day((8..16).to_a).
      minute_of_hour(0, 30) 
  end

  # Set the Sidekiq Queue to 'ios_alert_worker_queue', enable backtrace logging, and retry if the job fails
  sidekiq_options :queue => :android_alert_worker_queue, backtrace: true, retry: true

  def perform
    registration_ids = User.joins(:device).where('devices.platform = ?', 'android').
                          pluck('devices.token')
      # Android's GCM implementation will also accept an array of registration_ids, reducing the number of
      # requests we need to send (as long as our notification is common among all the devices)
      gcm = GCM.new(ENV['gcm_key'])
      options = {
        'data' => {
          'message' => "Hello from GCM!"
        },
          'collapse_key' => 'this_messages_key'
      }
      response = gcm.send_notification(registration_ids, options)
    end
  end
end