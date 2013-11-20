require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include ContactsHelper

  # Start and End Methods
  def setup
    @u = users(:one)
    @s = students(:one)
    @s.user_id = @u.id
    @s.save
    @c = contacts(:one)
    @c.student_id = @s.id
    @c.save

  	session[:user_id] = @u.id
  	session[:session_token] = @u.session_id
  end

  def teardown
    clean_db()
  end

  # action => new
  test "should get new" do
    get(:new, {'sid' => @s.id})
    assert_response :success

    student = assigns(:student)
    assert(@s.id == student.id)
  end

  test "should get Redirect from new" do
    get(:new, {'sid' => -1})
    assert_redirected_to dashboard_path
  end

  # action => create
  test "should create new contact" do
    # have to change email because that has to be unique
    c = contacts(:one)
    c.email = "sample@sample.com"
    
    post(:create, 
      { :sid => @s.id, :contact => {
        :name => c.name,
        :email => c.email,
        :phone => c.phone,
        :address => c.address,
        :billable => c.billable
      }, :format => :json})
    assert_response :success
  end

  # action => show
  test "should show contact" do
    get(:show, 'id' => @c.id)
    assert_response :success

    student = assigns(:student)
    assert(@s.id == student.id)

    contact = assigns(:contact)
    assert(@c.id == contact.id)
  end

  # action => edit
  test "should show edit contact" do
    get(:edit, 'id' => @c.id)
    assert_response :success

    contact = assigns(:contact)
    assert(@c.id == contact.id)
  end

  # action => update
  test "should edit contact" do
    c = contacts(:one)

    put :update, { :id => c.id, :sid => @s.id, :format => :json, :contact => {
      :name => c.name,
      :email => "changed@gmail.com",
      :phone => c.phone,
      :address => c.address,
      :billable => c.billable } }

    assert_response :success

    contact = Contact.find(c.id)
    assert_equal("changed@gmail.com", contact.email, "Contact email not updated")
  end

  test "Should destroy record" do
    c = contacts(:one)
    delete :destroy, :id => c.id

    contact = Contact.find_by_id(c.id)
    assert_nil(contact)
  end

  # helper functions
  test "verify user contact relationship" do
    assert verify_user_contact_relationship(@c.id)
  end

end
