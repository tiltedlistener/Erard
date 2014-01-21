class CalendarController < ApplicationController
	include SessionsHelper
	include CalendarHelper
  
  	def index
		@dates = get_week
	end

end
