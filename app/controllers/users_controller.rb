class UsersController < ApplicationController
    def show
        @user = User.find_by_id(params[:id])
        @blogs = Blog.all()
    end

    def index 
        @users = User.all 
    end
end
