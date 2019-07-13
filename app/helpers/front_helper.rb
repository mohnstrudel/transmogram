module FrontHelper
  include Pagy::Frontend

  def post_default_image_tag(object, version_name, &block)
    return nil unless object.images.any?
    begin
      image_tag object.images.first.value.url(version_name.to_sym)
    rescue => e
      puts "Error occured: #{e.message}"
    end
  end

  def dig_images(object:, kount: :first, attribute: "images", width: nil, height: nil, version: "medium")
    return "" unless object.send(attribute).present?

    if object.send(attribute).send(kount).active
      begin
        return image_tag(object.send(attribute).send(kount).image_value[version.to_sym].url, width: width, height: height)
      rescue => e
        puts "Error occured: #{e.message}"
      end
    else
      case version
      when "medium"
        return placeholdit_image_tag "248", text: "No active images!", background_color: '#E4CDAB'
      when "small"
        return placeholdit_image_tag "100", text: "No active images!", background_color: '#E4CDAB'
      when "supersmall"
        return placeholdit_image_tag "50", text: "No active images!", background_color: '#E4CDAB'
      end
    end
  end

  def dig_params(params)
    query = Array.new
    query << params[:query] if params[:query].present?
    query << ClassType.find(params[:class_type]).value if params[:class_type].present?
    query << ArmorType.find(params[:armor_type]).value if params[:armor_type].present?
    query.join(", ")
  end
end