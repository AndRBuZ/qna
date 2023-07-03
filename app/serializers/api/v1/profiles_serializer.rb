class Api::V1::ProfilesSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :created_at, :updated_at
end
