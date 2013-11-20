module StudentsHelper
	include SessionsHelper

	def verify_student_teacher_relationship(id)	
		u = get_user()
		s = u.students.find_by_id(id)
		if s.nil?
			return false
		else 
			return s
		end

	end

end
