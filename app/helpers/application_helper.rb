module ApplicationHelper

	def clean_name(name)
		return name
	end

	def clean_email(email)
		return email
	end

	def clean_phone(phone)
		return phone
	end

	def clean_address(address)
		return address
	end

	def clean_boolean(bool)
		return bool
	end

	def redirect_with_message (path, message)
		flash[:alert] = message
		redirect_to send("#{path}_path")
	end
	
end
