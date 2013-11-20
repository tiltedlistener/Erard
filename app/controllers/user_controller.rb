class UserController < ApplicationController
	include SessionsHelper
	
	before_filter :check_session_with_redirect
	
end
