FactoryGirl.define do
  factory :device do
    token SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
    platform 'IOS'
  end
end