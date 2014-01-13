class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :lat, :lng, :sex
  has_one :device
end
