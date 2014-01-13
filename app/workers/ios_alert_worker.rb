class IosAlertWorker
  include Sidekiq::Worker
  include Sidekiq::Schedulable

  # Sidetiq should schedule this job every half hour between 08:30 - 16:30 every Monday-Friday.
  # Note: The job will be queued at this time, not executed.
  recurrence do 
    weekly(1).
      day(:monday, :tuesday, :wednesday, :thursday, :friday).
      hour_of_day((8..16).to_a).
      minute_of_hour(0, 30) 
  end

  # Set the Sidekiq Queue to 'ios_alert_worker_queue', enable backtrace logging, and retry if the job fails
  sidekiq_options :queue => :ios_alert_worker_queue, backtrace: true, retry: true

  def perform
    # Keep the connection to gateway.push.apple.com open throughout the duration of this job
    pusher = Grocer.pusher(
      certificate: "/path/to/cert.pem",      # required
      passphrase:  "",                       # optional
      gateway:     "gateway.push.apple.com", # optional
      port:        2195,                     # optional
      retries:     3                         # optional
    )

    User.joins(:device).where('devices.platform = ?', 'ios').pluck('devices.token').each do |token|
      notification = Grocer::Notification.new(
        device_token:      token
        alert:             "Hello from Grocer!",
        badge:             42,
        sound:             "siren.aiff",         # optional
        expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
        identifier:        1234,                 # optional
        content_available: true                  # optional; any truthy value will set 'content-available' to 1
      )
      pusher.push(notification)
    end
  end
end