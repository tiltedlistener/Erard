class LessonsController < ApplicationController
	include ApplicationHelper
	include StudentsHelper
	include SessionsHelper
	include LessonsHelper
	
	before_filter :check_session_with_redirect
	
	def index
		@user = get_user()
		@lessons = @user.get_upcoming_lessons
	end

	def new
		user = get_user()
		@students = user.students.to_a
		@select_name = "lesson[student]"
		@form_name = "new_lesson"
		@lesson = Lesson.new

		# Time Format
		@year = Time.now.strftime("%y")
		@month = Time.now.strftime("%m")
		@day = Time.now.strftime("%e")
		@hour = Time.now.strftime("%-I")
		@minute = Time.now.strftime("%M")
		@time_of_day = 0

		respond_to do |format|
			format.js { render :layout => false }
			format.html
    	end
	end

	def create
		user = get_user()
		student = verify_student_teacher_relationship(params[:lesson][:student])
		lesson = student.lessons.new

  		shortime = params[:lesson][:time]
  		datetemp = construct_timezoned_date(user, shortime[:month], shortime[:day], shortime[:year], shortime[:hour], shortime[:minute], shortime[:ampm])

  		if (ensure_future_time(datetemp))
	  		lesson.schedule = datetemp
	  		lesson.save

			if lesson.errors.empty?
				msg = { :status => "ok", :message => "Success!" }
			else 
				msg = { :status => "error", :message => lesson.errors.full_messages[0]}
			end
		else
			msg = { :status => "error", :message => "Time must be set in the future" }
		end

		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def show
		user = get_user()
		@lesson = Lesson.find_by_id(params[:id])
		student = verify_student_teacher_relationship(@lesson)

		unless student.nil? || @lesson.nil?
			@formatted_time = @lesson.schedule.in_time_zone(user.get_user_timezone_code).strftime "%-I:%M%P %B %e, %Y"
		else 
			redirect_with_message("dashboard", "Lesson does not exist.")
		end
	end

	def edit
		user = get_user()		
		@lesson = Lesson.find_by_id(params[:id])
		@student = verify_student_teacher_relationship(@lesson.student_id)

		unless @student.nil? || @lesson.nil?
			formatted_time = @lesson.schedule.in_time_zone(user.get_user_timezone_code)

			# Time Format
			@year = formatted_time.strftime("%y")
			@month = formatted_time.strftime("%m")
			@day = formatted_time.strftime("%e")
			@hour = formatted_time.strftime("%-I")
			@minute = formatted_time.strftime("%M")
			@time_of_day = (formatted_time.strftime("%P") == "P") ? 0 : 1 

			# Form stuff
			# @students = user.students.all
			@select_name = "lesson[student]"
			@form_name = "edit_lesson"
		else 
			redirect_with_message("dashboard", "Lesson does not exist.")
		end
	end

	def update
		user = get_user()
		student = verify_student_teacher_relationship(params[:lesson][:student])
		lesson = student.lessons.find_by_id(params[:id])
	
		unless student.nil? || lesson.nil?
	  		shortime = params[:lesson][:time]
	  		datetemp =  construct_timezoned_date(user, shortime[:month], shortime[:day], shortime[:year], shortime[:hour], shortime[:minute], shortime[:ampm])

	  		if (ensure_future_time(datetemp))
	  			lesson.schedule = datetemp
	  			lesson.student_id = params[:lesson][:student]

				if lesson.save
					msg = { :status => "ok", :message => "Success!" }
				else 
					msg = { :status => "error", :message => lesson.errors.full_messages[0]}
				end
			else
				msg = { :status => "error", :message => "Time must be set in the future" }
			end

			respond_to do |format|
				format.json  { render :json => msg }
			end

		else
			redirect_with_message("dashboard", "Lesson does not exist.")
		end
	end

	def destroy
		lesson = Lesson.find_by_id(params[:id])
		student = verify_student_teacher_relationship(lesson.student_id)

		unless lesson.nil? || student.nil?
  			lesson.destroy
  			redirect_to lessons_path
  		else
  			redirect_with_message("dashboard", "Purchase not found.")
			return
  		end

	end

	# Assitant methods

	# used for partial display of an individual student
	def get_upcoming_by_student
		@user = get_user()
		student = verify_student_teacher_relationship(params[:id])

		unless student == false
			@lessons = student.get_upcoming_lessons

			unless student.nil?
				unless @lessons.nil? || @lessons.count == 0
					respond_to do |format|
			    		format.js { render "student_upcoming_individual", :layout => false, :status => :ok }
			    		format.html { redirect_to root_path }
			  		end
			  	else
					respond_to do |format|
			    		format.js { render :text=>"No upcoming lesson", :layout => false, :status => :ok }
			    		format.html { redirect_to root_path }
			  		end
			  	end
			else 
				redirect_to root_path
			end
		else
			redirect_to root_path
		end
	end

	# For showing everything
	def get_upcoming_all
		@user = get_user()
		@lessons = @user.get_upcoming_lessons

		unless @lessons.nil? || @lessons.count == 0
			respond_to do |format|
	    		format.js { render "student_upcoming", :layout => false, :status => :ok }
	    		format.html { redirect_to root_path }
	  		end
	  	else
			respond_to do |format|
	    		format.js { render :text=>"No upcoming lesson", :layout => false, :status => :ok }
	    		format.html { redirect_to root_path }
	  		end
	  	end

	end

	def get_unresolved_lessons
		@user = get_user()
		@lessons = @user.get_unresolved_lessons

		unless @lessons.nil? || @lessons.count == 0
			respond_to do |format|
	    		format.js { render "get_unresolved_lessons", :layout => false, :status => :ok }
	    		format.html { render "get_unresolved_lessons" }
	  		end
	  	else
			respond_to do |format|
	    		format.js { render :text=>"No unresolved lessons", :layout => false, :status => :ok }
	    		format.html { render "get_unresolved_lessons" }
	  		end
	  	end			
	end	

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:student_id, :paid, :updated_at, :schedule, :log, :resolved)
    end

end
