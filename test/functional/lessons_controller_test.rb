require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
	include LessonsHelper

	def setup
		unless (method_name == 'test_redirect_user_if_not_logged_in')
			# Setup Session
			@u = users(:one)
		  	session[:user_id] = @u.id
		  	session[:session_token] = @u.session_id

		  	# Setup Student
		  	@s = students(:one)
		  	@s.user_id = @u.id
		  	@s.save

		  	# Setup lesson
		  	@l = lessons(:one)
		  	@l.student_id = @s.id
		  	@l.save

		  	# Setup always future lesson
		  	@l2 = lessons(:three)
		  	@l2.student_id = @s.id
		  	@l2.schedule = Time.now + (52*7*24*60*60)
		  	@l2.save
		end
	end

	def teardown
		clean_db()
	end

	# Helper methods
	test "helper contsruct timezoned date and ensure future" do
		datetemp = construct_timezoned_date(@u, '09', "19", "14", "4", "12", "0") 
		assert_equal(datetemp, @l.schedule_in_user_zone(@u.get_user_timezone_code))

		assert ensure_future_time(Time.now + (52*7*24*60*60))

		# For some reason refute is not working
		assert(!ensure_future_time(Time.now - 1))
	end

	# Session Control
	test "redirect user if not logged in" do 
		get :index
		assert_redirected_to login_path
	end

	# action => index
	test "fetch index when logged in" do
		get :index
		assert_response :success
	end

	test "get all up lesson list on index" do
		get :index
		lessons = assigns(:lessons)

		# Lessons is two for the first YAML record and the always future lesson
		assert(lessons.count == 2)
	end

	#action => new
	test 'get new html/js and student list' do
		get :new
		assert_response :success

		students = assigns(:students)
		assert(students.count == 1)

		get :new, :format => :js
		assert_select 'div#lightbox-title', 'New Lesson'
	end

	# action => create
	test 'test create success methods' do 
		post(:create, {:format => :json, :lesson => { :student => @s.id , :time => {
				:month => Time.now.strftime("%m"),
				:year => Time.now.strftime("%y"), 
				:day => Time.now.strftime("%e"),
				:hour => Time.now.strftime("%-I"),
				:minute => Time.now.strftime("%M"), 
				:ampm => 0
			}}})
    	assert_response :success
	end

	# action => show
	test "should show lesson" do
		get(:show, :id => @l.id)
		assert_response :success

		lesson = assigns(:lesson)
		assert_equal @l.id, lesson.id

		time = assigns(:formatted_time)
		# assert_equal @l.schedule, time

		get(:show, :id => -1)
		assert_redirected_to dashboard_path
	end

	# action => edit
	test "should have data prepped for editing on lessons" do
		get(:edit, :id => @l.id)
		assert_response :success

		lesson = assigns(:lesson)
		student = assigns(:student)
		day = assigns(:day)

		assert_equal @l.id, lesson.id
		assert_equal @s.id, student.id
		assert_equal @l.schedule.strftime("%e"), day
	end

	# action => update
	test "should update lesson time" do
		put(:update, {:id => @l.id, :format => :json, :lesson => { :student => @s.id , :time => {
				:month => Time.now.strftime("%m"),
				:year => Time.now.strftime("%y"), 
				:day => Time.now.strftime("%e"),
				:hour => Time.now.strftime("%-I"),
				:minute => Time.now.strftime("%M"), 
				:ampm => 0
			}}})
    	assert_response :success
	end

	# action => destroy
	test "Should destroy record" do
		l = lessons(:one)
		delete :destroy, :id => l.id

		lesson = Lesson.find_by_id(l.id)
		assert_nil(lesson)
	end

	# support actions
	test "get upcoming by student" do
		get :get_upcoming_by_student, :id => @s.id

		lessons = assigns(:lessons)
		assert(lessons.count == 2)

		# JS service page
		assert_redirected_to root_path

		get :get_upcoming_by_student, { :id => @s.id, :format => :js }
		assert_response :success
		assert_select "div.upcoming-by-student"
	end

	test "get upcoming by empty" do
		student = students(:two)
		student.user_id = @u.id
		student.save

		get :get_upcoming_by_student, :id => student.id

		lessons = assigns(:lessons)
		assert(lessons.count == 0)

		get :get_upcoming_by_student, { :id => student.id, :format => :js }
		assert_response :success
		assert_equal "No upcoming lesson", @response.body
	end

	test "get upcoming by unassociated" do
		# Empty case
		student = students(:two)
		get :get_upcoming_by_student, :id => student.id
		assert_redirected_to root_path

		# Owned by another user
		user = users(:two)
		student.user_id = user.id
		student.save
		get :get_upcoming_by_student, :id => student.id
		assert_redirected_to root_path
	end

	test "get upcoming all" do
		get :get_upcoming_all
		assert assigns(:lessons).count == 2
		assert_redirected_to root_path

		get :get_upcoming_all, :format => :js
		assert_response :success
		assert_select "div.upcoming-by-student"
	end

	test "get upcoming all for empty" do
		@l.student_id = -1
		@l2.student_id = -1
		@l.save
		@l2.save

		get :get_upcoming_all
		assert assigns(:lessons).count == 0
		assert_redirected_to root_path

		get :get_upcoming_all, :format => :js
		assert_response :success
		assert_equal "No upcoming lesson", @response.body
	end

	test "get unresolved" do 
		get :get_unresolved_lessons
		assert_equal 2, assigns(:lessons).count

		get :get_unresolved_lessons, :format => :js
		assert_response :success
		assert_equal 2, assigns(:lessons).count
	end


end
