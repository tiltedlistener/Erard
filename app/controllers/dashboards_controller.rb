class DashboardsController < ApplicationController
	include SessionsHelper
	
	before_filter :check_session_with_redirect

	def index
		user = get_user()
	end

end
