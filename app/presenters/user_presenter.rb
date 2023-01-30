class UserPresenter

    attr_reader :params

    def initialize(params)
        @params = params
        @all_users = User.all
    end

    def filter
        @filter ||= UserFilter.new(@all_users , filter_params)
    end
    
    def users
        @users ||= filter.call
    end

    def populars
        @populars ||= @all_users.sort_by { |u| u.received_follows.size }.last(3)
    end

    def follower_count
        @follower_count ||= users.joins(:followers).group(:id).count()
    end 

    def following_count
        @following_count ||=  users.joins(:followings).group(:id).count()
    end

    private 

    def filter_params

        params.fetch(:user_filter, {}).permit(
            :name,
            :min_follow,
            :max_follow
        )
    end
end