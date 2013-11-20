require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase

	def setup

	end
	
	def teardown
		clean_db()
	end

	test "redirect to login when not logged in" do
		get :index
    	assert_redirected_to login_path
	end

	test "access index" do
	    @u = users(:one)
	  	session[:user_id] = @u.id
	  	session[:session_token] = @u.session_id
	  	get :index
	  	assert_response :success
	end

end
