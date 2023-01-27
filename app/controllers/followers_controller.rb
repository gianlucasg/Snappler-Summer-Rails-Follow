class FollowersController < ApplicationController
    before_action :set_current_user, only: [:follow, :unfollow]

    def follow
        @followed_user = params.require(:id_followed)
        if ! Follow.exists?(follower_id: @current_user[:id], followed_user_id: @followed_user)
            @follow_user = Follow.create!(follower_id: @current_user[:id], followed_user_id: @followed_user)
            if @follow_user.save
                redirect_to users_path
            end
        end
    end
    def unfollow
        @followed_user = params.require(:id_followed)
        if Follow.exists?(follower_id: @current_user[:id], followed_user_id: @followed_user)
            @unfollowed_user = Follow.find_by!(follower_id: @current_user[:id], followed_user_id: @followed_user)
            @unfollowed_user.destroy!
        end
        redirect_to users_path
    end
end
