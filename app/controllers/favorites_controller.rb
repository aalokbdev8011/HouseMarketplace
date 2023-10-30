# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authorize_request

  before_action :check_user, only: %i[index create destroy]
  before_action :check_favorite_property, only: [:create]

  def index
    favorites_list = current_user.favorites.map(&:property)
    render json: {properties: PropertySerializer.new(favorites_list).serializable_hash, items_count: favorites_list.count}
  end

  def create
    favorite = current_user.favorites.where(property_id: params[:property_id]).first
    if favorite
      favorite.destroy
      render json: { message: 'removed' }
    else
      favorite = current_user.favorites.create(property_id: params[:property_id])
      render json: { message: 'added' }
    end
  end

  def destroy
    @favorite = Favorite.where(property_id: params[:id], user_id: current_user.id).first
    return unless @favorite.destroy

    render json: { message: 'Property is removed in your favorites' }
  end

  private

  def check_user
    render json: { errors: 'You are not authorised user to perform this action' } unless current_user.role == 'user'
  end

  def check_favorite_property
    favorite = Favorite.find_by(property_id: params[:property_id])
    render json: { message: 'This property is already in your favorites list' } if favorite.present?
  end

  def update_property
    property = @favorite.property
    property.update(is_favorite: false)
  end
end
