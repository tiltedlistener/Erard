class PurchasesController < ApplicationController
	include ApplicationHelper
	include SessionsHelper
	include StudentsHelper
	include PurchasesHelper

	before_filter :check_session_with_redirect

	# Show all the purchases
	def index
		user = get_user()
		@purchases = user.purchases.where(:purchased => false).to_a
	end

	# Detail a single purhcase
	def show
		id = params[:id]
		if verify_user_purchase(id)
			@purchase = Purchase.find(id)
		else
			redirect_with_message("dashboard", "Purchase does not exist.")
		end
	end

	# Standard content management actions
	def new
		# Data setup
		user = get_user()
		@students = user.students.to_a
		@purchase = user.purchases.new

		# For select menu
		@select_name = "purchase[student]"
		@selected = 'false'

		# Form setup
		@form_name = 'new_purchase'

		respond_to do |format|
			format.js { render :layout => false }
			format.html
    	end
	end

	def create
		user = get_user()
		sid = params[:purchase][:student]

		purchase = user.purchases.new
		purchase.title = params[:purchase][:title]
		purchase.price = params[:purchase][:price]

		unless (sid == "nil")
			student = verify_student_teacher_relationship(params[:purchase][:student])

			unless student 
				redirect_with_message("dashboard", "Student not found.")
				return
			else 
				purchase.student_id = student.id
			end
		end

		purchase.save

		if purchase.errors.empty?
			msg = { :status => "ok", :message => "Success!" }
		else 
			message = purchase.errors.first
			msg = { :status => "error", :message => purchase.errors.full_messages[0]}
		end

		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def edit
		user = get_user()
		@purchase = user.purchases.find_by_id(params[:id])

		unless @purchase.nil?
			# setup form variables
			@form_name = 'edit_purchase'
			@select_name = "purchase[student_id]"		
			@students = user.students.to_a

			if (@purchase.student_id.nil?)
				@selected = 'nil'
			else
				@selected = @purchase.student_id
			end

		else
			# if we're not allowed, bounce us
			redirect_with_message("dashboard", "Student not found.")
			return
		end
	end

	def update
		user = get_user()

		# Verify that we have a realitionship or set to true if we didn't get a student relationship
		unless (params[:purchase][:student_id] == 'nil')
			student = verify_student_teacher_relationship(params[:purchase][:student_id])
		else 
			student = true
			params[:purchase][:student_id] = nil
		end


		if (student)
			purchase = user.purchases.find_by_id(params[:id])

			if purchase.update(purchase_params)
				msg = { :status => "ok", :message => "Success!" }
			else
				msg = { :status => "error", :message => purchase.errors.full_messages[0]}
	  		end		
		else
			msg = { :status => "error", :message => "Student not found."}
		end

  		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

	def destroy
		user = get_user()
		purchase = user.purchases.find_by_id(params[:id])

		unless purchase.nil?
  			purchase.destroy
  			redirect_to purchases_path
  		else
  			redirect_with_message("dashboard", "Purchase not found.")
			return
  		end
	end

	# Show list purchases by student
	def show_student
		student = verify_student_teacher_relationship(params[:sid])

		if (student)
			@name = student.name
			@purchases = student.purchases.where(:purchased => false).to_a
			@purchased  = student.purchases.where(:purchased => true).to_a
			@show_student = false
		else
			redirect_with_message("dashboard", "Student not found.")
			return
		end
	end

	# Past purchases all
	def show_past
		user = get_user()
		@purchased = user.purchases.where(:purchased => true).to_a
		@show_student = true
	end

	# Shows
	def review_upcoming_purchases
		user = get_user()
		@purchases = user.purchases.where(:purchased => false).to_a

		respond_to do |format|
    		format.js { render "review_upcoming_purchases", :layout => false, :status => :ok }
    		format.html { redirect_to dashboard_path }
  		end
	end	

	# Dynamically indicate item as purchased
	def purchase_item
		id = params[:id]
		purchase = Purchase.find(id)
		purchase.purchased = true

		if (purchase.save)
			msg = { :status => "ok", :message => "Success!" }
		else 
			msg = { :status => "error", :message => purchase.errors.full_messages[0]}
		end

		respond_to do |format|
			format.json  { render :json => msg }
		end
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:title, :price, :purchased, :student_id, :updated_at)
    end

end
