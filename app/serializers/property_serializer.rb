# frozen_string_literal: true

class PropertySerializer
  include JSONAPI::Serializer
  attributes :id, :title, :price, :city, :district, :address, :mrt_station, :property_type, :rooms, :created_at,
             :updated_at, :is_favorite

  attribute :image do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.image.blob, only_path: true) if object.image.attached?
  end

  attribute :is_favorite do |object, params|
    user = params[:user]
    user&.favorites&.find_by(property_id: object.id).present?
  end
end
