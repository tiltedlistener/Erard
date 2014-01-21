module CalendarHelper

	def get_week(user)

		t = Time.new

		case t.wday
			when 0
				result = day_sunday(user)
			when 1
				result = day_monday(user)
			when 2
				result = day_tuesday(user)
			when 3
				result = day_wednesday(user)
			when 4
				result = day_thursday(user)
			when 5
				result = day_friday(user)
			when 6
				result = day_saturday(user)
		end
		return result
	end

	def wrap_in_th(val)
		return '<th>' << val << '</th>'
	end

	def build_days(behind,ahead)
		t = Time.now
		day_time = 24*60*60
		increment = 0
		result = ''

		while increment < ahead
			t = t + (increment * day_time)
			result << wrap_in_th(t.in_time_zone(user.get_user_timezone_code).strftime "%-m/%e")
			increment += 1
		end
	end

	def day_sunday(user)

	end

	def day_monday

	end

	def day_tuesday

	end

	def day_wednesday

	end

	def day_thursday

	end

	def day_friday 

	end

	def day_saturday

	end

end
