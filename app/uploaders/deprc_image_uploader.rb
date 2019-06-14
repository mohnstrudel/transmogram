class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWaveDirect::Uploader
  # include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick
  include Amazon

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :check_if_allowed

  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :original do
    # after :store, :check_if_allowed
  end

  version :preview do
    process resize_to_fill: [269, 202]
  end

  version :medium do
    process resize_to_fill: [870, 569]
  end

  version :thumb_mini do
    process resize_to_fill: [170, 96]
  end

  version :quadratic do
    process resize_to_fill: [800, 800]
  end

  version :quadratic_small, from_version: :quadratic do
    process resize_to_fill: [100, 100]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def delete_if_not_allowed
    allowed = Amazon::ProcessImage.new.return_labels(self.file.path)
    puts "The image is allowed: #{allowed}"
    return if allowed
    # Delete image
    begin
      # self.model.remove_images!
      self.destroy
      if self.model.images.empty?
        self.model.destroy
      end
      # self.model.destroy
      # flash[:alert] = "Your uploaded files contain not allowed image content. Please upload world of warcraft content."
    rescue => e
      amazon_logger ||= Logger.new("#{Rails.root}/log/amazon_logger.log")
      amazon_logger.debug("While removing images from Carrierwave uploader something went wrong: #{e.message}.")
      # flash[:alert] = "Something went wrong during image upload. Our engineers were notified."
    end
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
