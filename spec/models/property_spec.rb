# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  it 'is not valid without required attributes' do
    property = Property.new
    expect(property).not_to be_valid
    expect(property.errors[:title]).to include("can't be blank")
    expect(property.errors[:city]).to include("can't be blank")
    expect(property.errors[:district]).to include("can't be blank")
    expect(property.errors[:price]).to include("can't be blank")
    expect(property.errors[:rooms]).to include("can't be blank")
    expect(property.errors[:mrt_station]).to include("can't be blank")
    expect(property.errors[:property_type]).to include("can't be blank")
  end

  it 'has many favorites' do
    association = described_class.reflect_on_association(:favorites)
    expect(association.macro).to eq :has_many
  end

  it 'has one attached images' do
    expect(described_class.new).to respond_to(:image)
  end
end
