module ContactsHelper
	include SessionsHelper

	def verify_user_contact_relationship(cid)
		contact = Contact.find(cid)

		unless contact.nil?
			student = Student.find(contact.student_id)

			sessid = get_user_id()
			user = User.find(sessid)
		
			if (student.user_id == user.id)
				return true
			else
				return false
			end
		else 
			return false
		end
	end

end
