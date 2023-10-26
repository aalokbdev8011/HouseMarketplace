# frozen_string_literal: true

class PropertySerializer
  include JSONAPI::Serializer
  attributes :id, :title, :price, :city, :district, :address, :mrt_station, :property_type, :rooms, :created_at,
             :updated_at

  attribute :image do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.image.blob, only_path: true) if object.image.attached?
  end
end
