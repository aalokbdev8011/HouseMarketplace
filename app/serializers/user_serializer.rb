# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :created_at, :role

  attribute :created_date do |user|
    user.created_at&.strftime('%m/%d/%Y')
  end
end
