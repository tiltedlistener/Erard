require 'test_helper'

class StudentsControllerTest < ActionController::TestCase

	def setup
		@u = users(:one)
		session[:user_id] = @u.id
		session[:session_token] = @u.session_id
		
		@s = students(:one)
		@s.user_id = @u.id
		@s.save

		@l = lessons(:one)
		@l.student_id = @s.id
		@l.save

		@c = contacts(:one)
		@c.student_id = @s.id
		@c.save
	end

	def teardown
		clean_db()
	end

	test "Get form for a new student" do 
		get :new
		assert_response :success

		get :new, :format => :js
		assert_response :success
	end

	test "Create new student" do
		post :create, { :student => { :name => @s.name }, :format => :json }
		assert_response :success

		post :create, { :student => { :name => "" }, :format => :json }
		json = JSON.parse(@response.body)
		assert_equal "error", json['status']

		post :create
		assert_redirected_to dashboard_path
	end

	test "Show an individual student" do
		get :show, :id => @s.id
		assert_response :success

		contacts = assigns(:contacts)
		assert_equal 1, contacts.count

		get :show, :id => -1
		assert_redirected_to dashboard_path
	end

	test "Show edit form for an individual student" do
		get :edit, :id => @s.id
		assert_response :success

		get :edit, :id => -1
		assert_redirected_to dashboard_path
	end

	test "Update a student's information" do
		put :update, { :id => @s.id, :student => { :name => "Tyler Willingham" }, :format => :json }
		assert_response :success

		student = Student.find(@s.id)
		assert_equal "Tyler Willingham", student.name

		put :update, { :id => @s.id, :student => { :name => " " }, :format => :json }
		json = JSON.parse(@response.body)
		assert_equal "error", json['status']
	end

	test "Delete a student and confirm their upcoming lessons are destroyed" do
		delete :destroy, :id => @s.id
		lesson_id = @l.id

	   	student = Student.find_by_id(@s.id)
	   	lesson = Lesson.find_by_id(lesson_id)
	    assert_nil(student)
	    assert_nil(lesson)
	end

	test "Review all the students owned by a user" do 
		get :review_students
		assert_redirected_to dashboard_path

		get :review_students, :format => :js
		assert_select "h2.title", "Students"

		students = assigns(:students)
		assert_equal 1, students.count
	end

end
