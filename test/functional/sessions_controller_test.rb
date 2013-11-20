require 'test_helper'
require 'base64'
require 'digest'

class SessionsControllerTest < ActionController::TestCase

	def setup
		@u = users(:one)
	end

	def teardown
		clean_db()
	end

	test "Invalid Login" do
		post :create, :email => 'taco@taco.com', :password => "taco"
		assert_equal I18n.t(:invalid_creds), flash[:alert]
		assert_nil session[:sesion_token]
		assert_redirected_to login_path
	end

	test "Create Session" do
		post :create, :email => @u.email, :password => 'stuffed'

		assert_not_nil session[:session_token]
		assert_equal @u.id, session[:user_id]

		user = User.find(@u.id)
		assert_equal user.session_id, session[:session_token]

		assert_redirected_to dashboard_path
	end

	test "Logout" do
		post :create, :email => @u.email, :password => 'stuffed'
		delete :destroy, :id => @u.id
		user = User.find(@u.id)
		assert_nil user.session_id
		assert_nil session[:session_token]
		assert_nil session[:user_id]
		assert_redirected_to root_path
	end


end
