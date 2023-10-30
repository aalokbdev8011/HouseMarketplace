# frozen_string_literal: true

class PropertySerializer
  include JSONAPI::Serializer
  attributes :id, :title, :price, :city, :district, :address, :mrt_station, :property_type, :rooms, :created_at,
             :updated_at, :is_favorite, :image_url

  attribute :image do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.image.blob, only_path: true) if object.image.attached?
  end

  attribute :is_favorite do |object, params|
    params[:user] ? object.favorites.find_by(user_id: params[:user].id).present? : false
  end
end
