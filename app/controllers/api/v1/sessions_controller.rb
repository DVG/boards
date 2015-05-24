module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate
      def create
        @user = User.find_by(username: params[:username]).try(:authenticate, params[:password])
        if @user
          render json: @user, serializer: SessionsSerializer, root: "session"
        else
          render json: { base: "The username or password you entered was incorrect" } , status: 422 
        end
      end

    end
  end
end