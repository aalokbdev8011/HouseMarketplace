# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_one_attached :image

  validates :title, :city, :district, :price, :rooms, :mrt_station, :property_type, presence: true

  before_save :update_image_url

  private

  def update_image_url
    self.image_url = self.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(self.image.blob, only_path: true) : self.image_url
  end
end
