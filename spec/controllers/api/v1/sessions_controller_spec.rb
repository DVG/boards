require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do

  let(:user) { create(:user) }
  let(:parsed_response) { JSON.parse(response.body) }
  context "successful validation" do
    before { post :create, username: user.username, password: user.password }
    it "returns an auth token" do
      expect(parsed_response["session"].keys).to include "auth_token"
    end
    it "returns the user's auth token" do
      expect(parsed_response["session"]["auth_token"]).to eq user.auth_token 
    end 
    it "returns the user's username" do
      expect(parsed_response["session"]["current_username"]).to eq user.username
    end
    it "returns the user's email" do
      expect(parsed_response["session"]["current_email"]).to eq user.email
    end
  end

  context "unsuccessful validation" do
    before { post :create, username: "blah", password: "blah" }
    it "returns a 422 unprocessible entity" do
      expect(response.status).to eq 422
    end
  end

end