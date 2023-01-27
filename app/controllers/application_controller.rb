class ApplicationController < ActionController::Base

    helper_method :current_user
    
    def set_current_user
        @current_user ||= User.first
    end

end
