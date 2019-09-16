module FrontHelper
  include Pagy::Frontend

  def post_default_image_tag(object, version_name, &block)
    return nil unless object.images.any?
    begin
      image_tag object.images.first.value.url(version_name.to_sym)
    rescue => e
      logger.info "Error occured: #{e.message}"
    end
  end

  def dig_avatar(object:, version: "small", css_class: nil, width: nil, height: nil, style: nil)
    if object.avatar.present?
      return image_tag(object.avatar[version.to_sym].url, class: css_class, style: style, width: width, height: height)
    else
      return placeholdit_image_tag "50", text: "N/A", background_color: '#E4CDAB', class: css_class, style: style, width: width, height: height
    end
  end

  def dig_images(object:, kount: :first, attribute: "images", width: nil, height: nil, version: "medium")
    # usage: in haml:
    # simple case -> = dig_images(object: post, version: "small")
    # full case -> = dig_images(object: post, kount: :second, attribute: "pictures", width: 512, height: 256, version: "huge")
    return "" unless object.send(attribute).present?

    if object.send(attribute).send(kount).active
      begin
        return image_tag(object.send(attribute).send(kount).image_value[version.to_sym].url, width: width, height: height)
      rescue => e
        logger.info "Error occured: #{e.message}"
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