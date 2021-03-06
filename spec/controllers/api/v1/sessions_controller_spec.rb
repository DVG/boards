require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do

  let(:user) { create(:user) }
  before { allow(AuthenticationToken).to receive(:generate_token) { "abc123" } }
  let(:parsed_response) { JSON.parse(response.body) }

  context "successful authentication" do
    before { post :create, username: user.username, password: user.password }
    it "returns an auth token" do
      expect(parsed_response["session"].keys).to include "auth_token"
    end
    it "returns the user's auth token" do
      expect(parsed_response["session"]["auth_token"]).to eq "abc123" 
    end 
    it "returns the user's username" do
      expect(parsed_response["session"]["current_username"]).to eq user.username
    end
    it "returns the user's email" do
      expect(parsed_response["session"]["current_email"]).to eq user.email
    end
  end

  context "unsuccessful authentication" do
    before { post :create, username: "blah", password: "blah" }
    it "returns a 422 unprocessible entity" do
      expect(response.status).to eq 422
    end
    it "returns a helpful message" do
      expect(parsed_response["base"]).to eq "The username or password you entered was incorrect"
    end
  end

end