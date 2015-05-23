module Api
  module V1
    class SessionsController < ApplicationController

      def create
        @user = User.find_by(username: params[:username]).authenticate(params[:password])
        render json: @user, serializer: SessionsSerializer, root: "session"
      end

    end
  end
end