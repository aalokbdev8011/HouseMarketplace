# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it 'belongs to a property' do
    association = described_class.reflect_on_association(:property)
    expect(association.macro).to eq :belongs_to
  end

  it 'belongs to a user' do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq :belongs_to
  end
end
