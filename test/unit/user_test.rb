require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @u = users(:one)
    @u.password = "tacotaco"
    @u.save

    @s = students(:one)
    @s.user_id = @u.id
    @s.save

    lesson = lessons(:one)
    lesson2 = lessons(:two)
    lesson4 = lessons(:four)

    lesson.student_id = @s.id
    lesson2.student_id = @s.id
    lesson4.student_id = @s.id
    lesson.save
    lesson2.save
    lesson4.save
  end

  def teardown
    clean_db()
  end

  test "Confirm authentication" do 
  	assert User.authenticate(@u.email, "tacotaco")
  	assert @u.authenticated?("tacotaco")
  end

  test "Validate Session" do
    assert User.validate_session(@u.id, @u.session_id)
  end

  test "Get Upcoming Lessons" do 
    lessons = @u.get_upcoming_lessons
    assert lessons.count == 2
  end

  test "Get all unresolved lessons" do
    lessons = @u.get_unresolved_lessons
    assert_equal 1, lessons.count
  end


end
