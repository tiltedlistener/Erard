require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  # Start and End Methods
  def setup
    @s = students(:one)
    @s2 = students(:two)

    @u = users(:one)

    @l3 = lessons(:three)
    @l4 = lessons(:four)

    @l3.student_id = @s2.id
    @l4.student_id = @s2.id

    @l3.save
    @l4.save
  end
  
  def teardown
    clean_db()
  end

  # Helper methods
  def build_lesson_list
    lesson = @s.lessons.new
    lesson.schedule = lessons(:one).schedule
    lesson.save

    lesson2 = @s.lessons.new
    lesson2.schedule = lessons(:two).schedule
    lesson2.save
  end

  test "Validate Student Presence Methods" do
  	student = Student.new
  	assert !student.save

  	student.name = "Carrie"
  	assert student.save
  end

  test "Ensure that User and Student Are Associated" do
  	s = @u.students.new
  	s.name = "Carrie"
  	assert s.save
  	assert s.user_id == @u.id

  	x = @u.students.find(s.id)
  	assert x
  	assert x.user_id == s.user_id
  end

  test "Get Lessons for a Student" do
    build_lesson_list()
    lessons = @s.get_lessons
    assert lessons.count == 2
  end

  test "Check get unpaid lessons" do
    build_lesson_list()
    lesson = @s.lessons.first
    lesson.paid = true
    lesson.save

    lessons = @s.get_unpaid_lessons
    assert lessons.count == 1
  end

  test "Get Upcoming Lessons" do
    build_lesson_list()
    lessons = @s.get_upcoming_lessons
    assert lessons.count == 2
  end

  test "Get Unresolved lessons in the past" do
    unresolved = @s2.get_unresolved_lessons 
    assert_equal 1, unresolved.count
  end

end
