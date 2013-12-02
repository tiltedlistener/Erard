require 'test_helper'

class CalendarControllerTest < ActionController::TestCase

	# Support
	def setup

	end
	
	def teardown

	end

	# Tests
	test "should get index" do
		get :index
		assert_response :success
	end

end
