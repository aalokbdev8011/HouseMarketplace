# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :favorites
  has_one_attached :image

  validates :title, :city, :district, :price, :rooms, :mrt_station, :property_type, presence: true
end
