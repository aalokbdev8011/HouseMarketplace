# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  before do
    @user = User.create(email: 'example@yopmail.com', password: '123456', role: 0)
    @property = Property.create(title: 'New Property', price: 30_000, address: 'city center', city: 'Mumbai',
                                district: 'Thane', rooms: 2, mrt_station: 'Thane station', property_type: 'residential')
    sign_in @user
    @favorite = Favorite.create(property_id: @property.id, user_id: @user.id)
  end

  describe 'GET #index' do
    it "returns a list of user's favorite properties" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns unauthorized for non-user roles' do
      @user.update(role: 'admin')
      get :index
      expect(JSON.parse(response.body)['errors']).to eq('You are not authorised user to perform this action')
    end
  end

  describe 'POST #create' do
    it "adds a property to user's favorites" do
      @favorite.destroy
      post :create, params: { property_id: @property.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['message']).to eq('Property is successfully added in your favorites')
    end

    it 'returns an error message if the property is already in favorites' do
      post :create
      expect(response).to have_http_status(422)
      expect(response.message).to eq('Unprocessable Entity')
    end

    it 'returns unauthorized for non-user roles' do
      @user.update(role: 'admin')
      post :create, params: { property_id: @property.id }
      expect(JSON.parse(response.body)['errors']).to eq('You are not authorised user to perform this action')
    end
  end
end
