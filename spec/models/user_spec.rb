# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes with role user' do
    user = User.new(
      email: 'test@example.com',
      password: 'password123',
      role: 'user'
    )
    expect(user).to be_valid
  end

  it 'is not valid without an email with role user' do
    user = User.new(
      email: nil,
      password: 'password123',
      role: 'user'
    )
    expect(user).not_to be_valid
  end

  it 'is not valid without a password with role user' do
    user = User.new(
      email: 'test@example.com',
      password: nil,
      role: 'user'
    )
    expect(user).not_to be_valid
  end

  it 'is valid with valid attributeswith role admin' do
    user = User.new(
      email: 'test@example.com',
      password: 'password123',
      role: 'admin'
    )
    expect(user).to be_valid
  end

  it 'is not valid without an email with role admin' do
    user = User.new(
      email: nil,
      password: 'password123',
      role: 'admin'
    )
    expect(user).not_to be_valid
  end

  it 'is not valid without a password with role admin' do
    user = User.new(
      email: 'test@example.com',
      password: nil,
      role: 'admin'
    )
    expect(user).not_to be_valid
  end

  it 'has many favorites' do
    association = described_class.reflect_on_association(:favorites)
    expect(association.macro).to eq :has_many
  end
end
