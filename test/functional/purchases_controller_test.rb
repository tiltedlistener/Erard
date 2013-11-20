require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
	include PurchasesHelper

	def setup
		@u = users(:one)
		session[:user_id] = @u.id
		session[:session_token] = @u.session_id

		@s = students(:one)
		@s.user_id = @u.id
		@s.save

		@p = purchases(:one)
		@p2 = purchases(:two)
		@p.student_id = @s.id
		@p.user_id = @u.id
		@p2.user_id = @u.id
		@p.save
		@p2.save
	end

	def teardown
		clean_db()
	end

	test "index logged and not" do
		session[:session_token] = nil
		get :index
		assert_redirected_to login_path

		session[:session_token] = @u.session_id
		get :index
		assert_response :success

		assert assigns(:purchases).count == 1
	end

	test "show purchase and nonexistent" do
		get :show, :id => @p.id
		assert_response :success

		purchase = assigns(:purchase)
		assert_equal @p.id, purchase.id

		get :show, :id => -1
		assert_redirected_to dashboard_path
	end

	test "new" do
		get :new
		students = assigns(:students)
		assert students.count == 1, students.count
		assert_response :success

		get :new, :format => :js
		assert_response :success
	end

	test "create" do
		p = purchases(:one)

		#with and w/o student
	    post(:create, 
	      { :purchase => {
	      		:student => @s.id,
	      		:title => p.title,
	      		:price => p.price
	      }, :format => :json})
	    assert_response :success


	    post(:create, 
	      { :purchase => {
	      		:student => "nil",
	      		:title => p.title,
	      		:price => p.price
	      }, :format => :json})
	    assert_response :success

	    # unrelated student
	    @s.user_id = -1
	    @s.save

	    post(:create, 
	      { :purchase => {
	      		:student => @s.id,
	      		:title => p.title,
	      		:price => p.price
	      }, :format => :json})
	    assert_redirected_to dashboard_path
	end

	test "edit" do
		get :edit, :id => -1
		assert_redirected_to dashboard_path

		get :edit, :id => @p.id
		p = assigns(:purchase)
		assert_equal @p.id, p.id

		s = assigns(:students)
		assert_equal 1, s.count

		selected = assigns(:selected)
		assert_equal @s.id, selected

		get :edit, :id => @p2.id
		sel2 = assigns(:selected)
		assert_equal "nil", sel2

	end

	test "update" do
	    put :update, 
	      { :id => @p.id, :format => :json, :purchase => {
	      		:student_id => @p.student_id,
	      		:title => "Mozart",
	      		:price => @p.price
	      }}
	    assert_response :success
	    purchase = Purchase.find_by_id(@p.id)
	    assert_equal "Mozart", purchase.title

	    # Student Nil
	    put :update, 
	      { :id => @p2.id, :format => :json, :purchase => {
	      		:student_id => "nil",
	      		:title => "Mozart",
	      		:price => @p2.price
	      }}
	    assert_response :success
	    purchaseAgain = Purchase.find_by_id(@p2.id)
	    assert_equal "Mozart", purchaseAgain.title


	    # Student not found
	    @p2.user_id = users(:two).id
	    @p2.student_id = -1
	    @p2.save

		put :update, 
			{ :id => @p2.id, :format => :json, :purchase => {
				:student_id => @p2.student_id,
				:title => "Mozart",
				:price => @p2.price
			}}

		json = JSON.parse(@response.body)
		assert_equal "error", json['status']
	end

	test "destroy" do
		p = purchases(:one)
		delete :destroy, :id => p.id

	    purchase = Purchase.find_by_id(p.id)
	    assert_nil(purchase)
	end

	test "Show Student's Purchases" do
		post :show_student, :sid => -1
		assert_redirected_to dashboard_path

		@p2.student_id = @s.id
		@p2.save
		post :show_student, :sid => @s.id

		name = assigns(:name)
		purchases = assigns(:purchases)
		purchased = assigns(:purchased)

		assert_equal purchases.count, 1
		assert_equal purchased.count, 1
		assert_equal @s.name, name
	end

	test "Show Past Purchases" do
		post :show_past
		purchased = assigns(:purchased)
		assert_equal 1, purchased.count
	end

	test "Review Upcoming purchased" do
		post :review_upcoming_purchases

		purchases = assigns(:purchases)
		assert_equal 1, purchases.count

		assert_redirected_to dashboard_path

		post :review_upcoming_purchases, :format => :js
		assert_select "h2.title", "To Purchase"
	end

	test "Purchase Item" do
		post :purchase_item, {:format=>:json, :id => @p.id}
		purchase = Purchase.find(@p.id)
		assert purchase.purchased
	end

end
