require 'spec_helper'

describe Api::V1::UsersController do
  let!(:permitted_app) { FactoryGirl.create(:permitted_app) }
  let!(:headers) { {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(permitted_app.authentication_token)} }

  describe "UsersController#create" do
    it "should be able to create a new user" do
      post_via_redirect('/api/users', { user: { email: 'test@example.com', sex: 'male', lat: '32.823', lng: '832.00', 
        device_attributes: {token: '12345678910', platform: 'iOS'} }, format: :json }, headers)
      response.should be_success
      JSON.parse(response.body)['id'].should be_a_kind_of(Fixnum)
      JSON.parse(response.body)['email'].should == 'test@example.com' 
      JSON.parse(response.body)['device']['id'].should be_a_kind_of(Fixnum)
    end 
  end

  describe "UsersController#destroy" do
    let(:user) { FactoryGirl.create(:user) }

    it { user.persisted?.should be_true }

    it "should destroy the user" do
      delete_via_redirect("/api/users/#{user.email.friendlyerize}", { format: :json }, headers)
      response.should be_success
      response.status.should eq 200 
    end
  end

  describe "UsersController#update" do
    let(:user) { FactoryGirl.create(:user) }

    it { user.persisted?.should be_true }

    it "should update the user" do
      patch("/api/users/#{user.email.friendlyerize}", { format: :json, 
        user: { 
          email: 'poop@example.com', lat: '832.02', lng: '21.21',
          device_attributes: { id: user.device.id, platform: 'ios', token: 'hello' } 
        }
      }, headers)

      response.should be_success
      JSON.parse(response.body)['email'].should eq 'poop@example.com'
      JSON.parse(response.body)['device']['token'].should eq 'hello'
    end
  end

  describe "UsersController#show" do
    let(:user) { FactoryGirl.create(:user) }

    it "should retrieve a single user" do
      get("/api/users/#{user.email.friendlyerize}", { format: :json }, headers)
      
      response.should be_success
      JSON.parse(response.body).keys.should include('id', 'email', 'sex', 'lat', 'lng', 'device')
    end
  end

  describe "UsersController#index" do
    before do
      10.times { FactoryGirl.create(:user) }
    end

    it "should retrieve all of the users" do
      get("/api/users/", { format: :json }, headers)
      
      response.should be_success
      JSON.parse(response.body).size.should eq 10
      JSON.parse(response.body).first.keys.should include("device")
    end
  end
end