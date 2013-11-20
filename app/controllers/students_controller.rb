class StudentsController < ApplicationController
	include StudentsHelper
	include SessionsHelper
	
	before_filter :check_session_with_redirect

	def index 
		user = get_user()
		@students = user.students.to_a
	end

	def new 
		@student = Student.new
		@form_name = "new_student"

		respond_to do |format|
			format.js { render :layout => false }
			format.html
    	end

	end

	def create 
		unless request.format.html?
			user = get_user()

			name = params[:student][:name].strip.squeeze(" ")   
			s = user.students.new
			s.name = name
			s.save

			if s.errors.empty?
				msg = { :status => "ok", :message => "Success!" }
			else 
				message = s.errors.first
				msg = { :status => "error", :message => s.errors.full_messages[0]}
			end

			respond_to do |format|
				format.json  { render :json => msg }
			end
		else 
			redirect_to dashboard_path
		end
	end

	def show
		@student = verify_student_teacher_relationship(params[:id])

	    unless @student 
			flash[:alert] = "Student not found."
			redirect_to dashboard_path
		else 
			@contacts = @student.contacts.to_a
		end
	end

	def edit 
		@student = verify_student_teacher_relationship(params[:id])
	    unless @student 
			flash[:alert] = "Student not found."
			redirect_to dashboard_path
		else 
			@form_name = 'edit_student'
		end
	end

	def update 
		unless request.format.html?
			@student = verify_student_teacher_relationship(params[:id])

			if @student.update(student_params)
				msg = { :status => "ok", :message => "Success!" }
			else
				msg = { :status => "error", :message => @student.errors.full_messages[0]}
	  		end		

	  		respond_to do |format|
				format.json  { render :json => msg }
			end
		else 
			redirect_to dashboard_path
		end
	end

	def destroy
		@student = verify_student_teacher_relationship(params[:id])
  		@student.destroy
  		redirect_to dashboards_path
	end

	# Support Controllers
	def review_students
		user = get_user()
		@students = user.students.to_a

		respond_to do |format|
    		format.js { render "review_students", :layout => false, :status => :ok }
    		format.html { redirect_to dashboard_path }
  		end
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :updated_at, :rate, :invoice_period, :last_invoice)
    end
end
