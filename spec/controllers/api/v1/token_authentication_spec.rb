require 'rails_helper'

RSpec.describe "Token Authentication", type: :controller do
  controller do
    def index
    end
  end

  describe "current_user" do
    let!(:user) { create(:user) }    
    let(:token) { user.auth_token }
    let(:parsed_response) { JSON.parse response.body }
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token, identity: user.email)
    end
    context "Valid Token" do
      it "sets current user based on the auth token" do
        get :index
        expect(assigns(:current_user)).to eq user
      end
    end

    context "invalid token" do
      let(:token) { "A Bunch of crap" }
      it "renders 401 unauthorized with a bad auth token" do
        get :index
        expect(response.status).to eq 401
      end

      it "Returns a helpful message" do
        get :index
        expect(parsed_response["message"]).to eq "Bad credentials"
      end
    end


  end
end