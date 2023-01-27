class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :set_current_user, only: [:index]
    
    def index #ruta a /users
        @users = User.all
        @followornot = @current_user.followings
        @populars = @users.sort_by { |u| u.received_follows.size }.last(3)
        @follower_count = @users.joins(:followers).group(:id).count()
        @following_count =  @users.joins(:followings).group(:id).count()
        respond_to do |format|
            format.json {render json: build_json_index}
            format.html
        end
    
    end

    #ruta /users/id
    def show; 
        @followed_users = @user.followings.pluck(:name)
        @followers = @user.followers.pluck(:name)
        respond_to do |format|
            format.json {render json: build_json_show}
            format.html
        end
    end

    def create #es un post del nuevo usuario
        @user = User.create(user_params)
        if @user.save
            redirect_to users_path
        end
    end

    def new #ruta /users/new apunta a vista para crear nuevo usuario
        @user = User.new
    end

    def edit; end

    def update
        if @user.update(user_params)
            redirect_to @user
        end
    end

    def destroy
        Follow.where(follower_id: @user[:id]).or(followed_user_id: @user[:id]).destroy_all
        @user.destroy!
        redirect_to users_path
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name,:age)
    end

    def build_json_index
    {
        user_list: @users,
        follower_count: @follower_count,
        following_count: @following_count
    }
    end

    def build_json_show
    {
        user: @user,
        followed_users: @followed_users ,
        followers: @followers
    }
    end
end
