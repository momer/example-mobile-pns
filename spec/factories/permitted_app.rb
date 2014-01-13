FactoryGirl.define do
  factory :permitted_app do
    authentication_token SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
  end
end