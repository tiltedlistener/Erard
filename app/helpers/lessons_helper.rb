module LessonsHelper

	def construct_timezoned_date(user, month, day, year, hour, minute, ampm)
		Time.zone = user.get_user_timezone_code
		year = ('20' + year).to_i
		month = month.to_i
		day = day.to_i
		hour = (ampm === '0') ? hour.to_i + 12 : hour
		minute = minute.to_i
  		datetemp = Time.zone.local(year, month, day, hour, minute)
  		return datetemp
	end

	def ensure_future_time(time)
		if (time <= Time.now)
			return false
		else
			return true
		end
	end

end
