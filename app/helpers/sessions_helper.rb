module SessionsHelper

	def check_session_with_redirect
		unless (User.validate_session(session[:user_id], session[:session_token]))
			flash[:alert] = "Please login."
			redirect_to login_path
		end
	end

	def check_user_state
		return User.validate_session(session[:user_id], session[:session_token])
	end

	def get_user_id
		if (check_user_state())
			return session[:user_id]
		else 
			# This is for the case where a user does not validate but is somehow inside the application
			# In other words - BOUNCE 'em!
			reset_session
			flash[:alert] = "An error has occurred regarding your account."
			redirect_to login_path			
		end
	end

	def get_user
		session = get_user_id()
		user = User.find(session)
		return user
	end

end
