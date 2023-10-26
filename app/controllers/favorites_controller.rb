# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :check_user, only: %i[index create delete]
  before_action :check_favorite_property, only: [:create]

  def index
    favorites_list = current_user.favorites.map(&:property)
    render json: PropertySerializer.new(favorites_list).serializable_hash
  end

  def create
    favorite = Favorite.new(user_id: current_user.id, property_id: params[:property_id])
    if favorite.save
      render json: { message: 'Property is successfully added in your favorites' }
    else
      render json: { message: favorite.errors.full_messages }, status: 422
    end
  end

  def delete
    favorite = Favorite.find_by(id: params[:id])
    return unless favorite.destroy

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
end
