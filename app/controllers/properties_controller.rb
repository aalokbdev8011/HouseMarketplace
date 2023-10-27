# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action(:authorize_request, if: ->  { request.headers['Authorization'].present? })
  before_action :set_property, only: %i[show update destroy]
  before_action :check_admin, only: %i[create update destroy]

  def index
    page_number = params[:page] || 1
    properties = Property.order("id desc").paginate(page: page_number, per_page: 6)

    render json: { properties: PropertySerializer.new(properties, params: {user: current_user}).serializable_hash, items_count: Property.count}
  end

  def create
    property = Property.new(property_params)
    property.district << params[:district]
    if property.save
      render json: { message: 'Property is successfully created',
                     property: PropertySerializer.new(property).serializable_hash }
    else
      render json: { message: property.errors.full_messages }, status: 422
    end
  end

  def show
    render json: PropertySerializer.new(@property).serializable_hash
  end

  def update
    if @property.update(property_params)
      render json: { property: PropertySerializer.new(@property).serializable_hash,
                     message: 'Property is successfully updated' }
    else
      render json: { message: @property.errors.full_messages }, status: 422
    end
  end

  def destroy
    @property.destroy
    render json: { message: 'Property is deleted successfully' }
  end

  def filter_properties
    page_number = params[:page] || 1
    properties = filtered_data

    if properties.present?
      render json: { properties: PropertySerializer.new(properties.paginate(page: page_number, per_page: 6)).serializable_hash, items_count: properties.count }
    else
      render json: { message: 'No Properties found' }
    end
  end

  private

  def property_params
    params.require(:property)
          .permit(:title, :price, :city, :address, :mrt_station, :property_type, :rooms,
                  :image)
  end

  def set_property
    @property = Property.find_by(id: params[:id])
    render json: { message: 'No property there' } unless @property.present?
  end

  def check_admin
    return if current_user&.role == 'admin'

    render json: { errors: 'You are not authorised user or logged in to perform this action' }
  end

  def check_price?
    params[:price_min].present? && params[:price_max].present?
  end

  def filtered_data
    properties = Property.all
    properties = properties.where(city: params[:city]) if params[:city].present?
    properties = properties.where(district: params[:district]) if params[:district].present?
    properties = properties.where(price: params[:price_min].to_d..params[:price_max].to_d) if check_price?
    properties = properties.where(property_type: params[:property_type]) if params[:property_type].present?
    properties
  end
end
