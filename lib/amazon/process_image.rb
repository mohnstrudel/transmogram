require 'dotenv'
# require 'aws-sdk'

module Amazon
  class ProcessImage

    def initialize
      Dotenv.load
      @client = Aws::Rekognition::Client.new(region: Figaro.env.amazon_region, access_key_id: Figaro.env.amazon_access, secret_access_key: Figaro.env.amazon_secret)
    end

    def return_labels(image)
      # byebug
      response = @client.detect_labels({
        image: {
          s3_object: {
            bucket: Figaro.env.amazon_bucket,
            name: image,
          },
        },
        max_labels: 50,
        min_confidence: 50,
      })

      p response.to_h

      evaluate_for_wow(response)
    end

    def evaluate_for_wow(response)
      allowed = false
      @label_logger ||= Logger.new("#{Rails.root}/log/label_logger.log")
      allowed_labels = ["World Of Warcraft", "Game"]
      # Das ist beispielsweise so:
      # [{:name=>"Human", :confidence=>77.12277221679688, :instances=>[], :parents=>[]},
      # {:name=>"Person", :confidence=>77.12277221679688, :instances=>[{:bounding_box=>{:width=>0.21008287370204926, :height=>0.8677554726600647, :left=>0.4075268507003784, :top=>0.07636458426713943}, :confidence=>77.12277221679688}], :parents=>[]},
      # {:name=>"World Of Warcraft", :confidence=>73.37450408935547, :instances=>[], :parents=>[]},
      # {:name=>"Overwatch", :confidence=>57.32423782348633, :instances=>[], :parents=>[]}]
      response = response.to_h[:labels]
      response.each do |label|
        @label_logger.info("Adding new label: #{label[:name]}")

        if allowed_labels.any? { |value| label.has_value?(value)}
          if label[:confidence] > 20
            allowed = true
          end
        end
      end
      return allowed

    end
  end
end

