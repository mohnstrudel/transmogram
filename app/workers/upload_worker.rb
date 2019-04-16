class UploadWorker
  include Sidekiq::Worker

  def perform(post_id)
    # Do something
    post = Post.find(post_id)
    post.save
  end
end
