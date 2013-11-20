require 'base64'
require 'digest'

class SessionsController < ApplicationController

	def create
		if user = User.authenticate(params[:email], params[:password])
			session[:user_id] = user.id
			session[:session_token] = Digest::SHA1.hexdigest([Time.now, rand].join)
			user.session_id = session[:session_token]
			user.save
			redirect_to dashboard_path
		else 
			flash[:alert] = t(:invalid_creds)
			redirect_to login_path
		end
	end

	def destroy 
		if user = User.find_by_session_id(session[:session_token])
			user.session_id = nil
			user.save
		end
		reset_session
		redirect_to root_path
	end

	def notify 
		@data = OpenStruct.new
		note = Notification.new
		note.email = params[:email]

		if note.save
			@data.result = true
		else 
			@data.result = false
			@data.message = note.errors.full_messages[0]
		end

		respond_to do |format| 
			format.json  { render :json => @data}
		end 
	end

end
