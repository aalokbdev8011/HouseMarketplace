# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :property
  belongs_to :user

  after_save :update_is_favorite

  private

  def update_is_favorite
    self.property.update(is_favorite: true)
  end

end
