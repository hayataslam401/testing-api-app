module Api
  module V1
    class UsersController < ApplicationController
    
      def index
        @users = User.all
        render json: {users: @users.map{|user|
          user.attributes.merge(Avatar: user.avatar.attached? ? url_for(user.avatar) : nil,
           Posts: user.posts,
            comments: user.comments) 
            }},
             status: :ok
      end
    
      def show
        @user= User.find_by_id(params[:id])
        render json: { email: @user.email , avatar: url_for(@user.avatar)}, status: :ok
      end
    end
  end
end