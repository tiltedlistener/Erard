require 'test_helper'

class LessonTest < ActiveSupport::TestCase

	def setup
		@u = users(:one)
		@s = students(:one)

		@l = lessons(:one)
		@l.student_id = @s.id
		@l.save
	end

	def teardown
		clean_db()
	end

	test "schedule in user zone" do 
		# in this case the user is in PST
		testable = @l.schedule_in_user_zone(@u.get_user_timezone_code)
		assert("2014-09-19 16:12:00 -0700", testable)
	end


end
