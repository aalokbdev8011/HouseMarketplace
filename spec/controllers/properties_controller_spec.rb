# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertiesController, type: :controller do
  let(:admin_user) { User.create(email: 'example@yopmail.com', password: '123456', role: 'admin') }
  let(:user) { User.create(email: 'example@yopmail.com', password: '123456', role: 'user') }
  let(:valid_property_params) do
    { title: 'Sample Property', price: 1000, city: 'taipei', address: 'Sample Address', property_type: 'residential',
      rooms: 2, mrt_station: 'taipei station', district: 'taipei district' }
  end
  let(:property) { Property.create(valid_property_params) }

  describe 'GET #index' do
    it 'returns a list of properties in JSON format' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new property' do
        sign_in admin_user
        post :create, params: { property: valid_property_params }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to eq('Property is successfully created')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error message' do
        sign_in admin_user
        post :create, params: { property: { title: '' } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when user is not an admin' do
      it 'returns an error message' do
        sign_in user
        post :create, params: { property: valid_property_params }
        expect(JSON.parse(response.body)['errors']).to eq('You are not authorised user to perform this action')
      end
    end
  end

  describe 'GET #show' do
    it 'returns the property in JSON format' do
      get :show, params: { id: property.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'returns an error if the property does not exist' do
      get :show, params: { id: 999 }
      expect(JSON.parse(response.body)['message']).to eq('No property there')
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the property' do
        sign_in admin_user
        patch :update, params: { id: property.id, property: { title: 'New Title' } }
        expect(response).to have_http_status(:success)
        expect(property.reload.title).to eq('New Title')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error message' do
        sign_in admin_user
        patch :update, params: { id: property.id, property: { title: '' } }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to include("Title can't be blank")
      end
    end

    context 'when user is not an admin' do
      it 'returns an error message' do
        sign_in user
        patch :update, params: { id: property.id, property: { title: 'New Title' } }
        expect(JSON.parse(response.body)['errors']).to eq('You are not authorised user to perform this action')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the property' do
      sign_in admin_user
      delete :destroy, params: { id: property.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['message']).to eq('Property is deleted successfully')
    end

    it 'returns an error if the property does not exist' do
      sign_in admin_user
      delete :destroy, params: { id: 999 }
      expect(JSON.parse(response.body)['message']).to eq('No property there')
    end

    context 'when user is not an admin' do
      it 'returns an error message' do
        sign_in user
        delete :destroy, params: { id: property.id }
        expect(JSON.parse(response.body)['errors']).to eq('You are not authorised user to perform this action')
      end
    end
  end
end
