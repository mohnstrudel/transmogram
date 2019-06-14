require "image_processing/mini_magick"

class ImageUploader < Shrine
  #plugins and uploading logic

  plugin :processing # allows hooking into promoting
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading

  plugin :validation_helpers
  plugin :determine_mime_type

  Attacher.validate do
    validate_min_size 1, message: "must not be empty"
    validate_max_size 10*1024*1024, message: "is too large (max is 10 MB)"
    validate_mime_type_inclusion %w[image/jpeg image/png image/tiff]
    validate_extension_inclusion %w[jpg jpeg png tiff tif]
  end

  process(:store) do |io, context|
    versions = { original: io } # retain original

    # download the uploaded file from the temporary storage
    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:supersmall] = pipeline.resize_to_fill!(50, 50)
      versions[:small] = pipeline.resize_to_fill!(100, 100)
      versions[:medium] = pipeline.resize_to_fill!(269, 202)
      versions[:large] = pipeline.resize_to_fill!(870, 569)
    end

    versions
  end
end