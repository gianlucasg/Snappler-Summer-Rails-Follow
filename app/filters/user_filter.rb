class UserFilter

    include ActiveModel::API
    include ActiveModel::Attributes

    attribute :name,        :string
    attribute :min_follow,  :integer
    attribute :max_follow,  :integer

    attr_reader :users

    def initialize(scope,params)
        super(params)
        @users = scope
    end

    def call
        by_name!
        by_min_follow!
        by_max_follow!
        
        users
    end
    
    def by_name!
        return if name.blank?
        @users = users.where("users.name LIKE ?", "%" + name + "%")
        @users = users.where(name: name)
    end

    def by_min_follow!
        return if min_follow.blank?
        byebug
        @users = users.select { |user| user.received_follows.size >= min_follow}
        
    end

    def by_max_follow!
        return if max_follow.blank?
        @users = users.select { |user| user.received_follows.size <= max_follow}

    end
end