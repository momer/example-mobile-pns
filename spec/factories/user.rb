FactoryGirl.define do
  factory :user do
    email SecureRandom.hex(8).concat("@example.com")
    sex ['male', 'female'].sample
    lat '32.32'
    lng '32.32'

    association :device, factory: :device, 
      token: SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz'),
      platform: 'iOS'
  end
end