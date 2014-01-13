class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :token, :platform
end
