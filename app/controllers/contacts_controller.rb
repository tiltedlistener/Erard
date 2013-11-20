class ContactsController < ApplicationController
	include ApplicationHelper
	include StudentsHelper
	include ContactsHelper
	include SessionsHelper
	
	before_filter :check_session_with_redirect

	def new
		@sid = params[:sid]
		@student = verify_student_teacher_relationship(params[:sid])

		if (@student != false)
			@contact = @student.contacts.new
			@form_name = "new_contact"
		else
			flash[:alert] = "Student ID does not exist."
			redirect_to dashboard_path
		end
	end

	def create
		student = verify_student_teacher_relationship(params[:sid])

		if (student != false)
			contact = student.contacts.new
			contact.name = clean_name(params[:contact][:name])
			contact.email = clean_email(params[:contact][:email])
			contact.phone = clean_phone(params[:contact][:phone])
			contact.address = clean_address(params[:contact][:address])

			if (params[:contact][:billable])
				contact.billable = params[:contact][:billable]
			end 

			contact.save

			if contact.errors.empty?
				message = "Success!"
				msg = { :status => "ok", :message => message }
			else 
				message = contact.errors.first
				msg = { :status => "error", :message => contact.errors.full_messages[0]}
			end		
		else 
			message = "Student ID does not exist."
			msg = { :status => "error", :message => message }	
		end

		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def show
		if (verify_user_contact_relationship(params[:id]))
			@contact = Contact.find(params[:id])
			@student = Student.find(@contact.student_id)
		else
			flash[:alert] = "Contact does not exist."
			redirect_to dashboard_path
		end
	end

	def edit
		if (verify_user_contact_relationship(params[:id]))
			@contact = Contact.find(params[:id])
			@sid = @contact.student_id
			@form_name = "edit_contact"
		else
			flash[:alert] = "Contact does not exist."
			redirect_to dashboard_path
		end
	end

	def update
		student = verify_student_teacher_relationship(params[:sid])

		if (student != false)
			contact = Contact.find(params[:id])
			contact.update(contact_params)

			if contact.errors.empty?
				msg = { :status => "ok", :message => "Success!" }
			else 
				message = contact.errors.first
				msg = { :status => "error", :message => contact.errors.full_messages[0]}
			end	
		else 
			message = "Student ID does not exist."
			msg = { :status => "error", :message => message}	
		end

		respond_to do |format|
			format.json  { render :json => msg }
		end

	end

	def destroy
		contact = Contact.find(params[:id])
		student = verify_student_teacher_relationship(contact.student_id)
  		contact.destroy
  		redirect_to student
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :email, :phone, :address, :billable)
    end

end
