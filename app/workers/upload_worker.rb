class UploadWorker
  include Sidekiq::Worker
  # sidekiq_options queue: 'carrierwave'
  # sidekiq_options retry: false

  def perform(post_id)
    puts "Upload worker performed, did nothing"
  end
end
