require 'digest'
class User < ActiveRecord::Base

	has_many :students
	has_many :newsletters
	has_many :purchases

	attr_accessor :password

	validates :name, :email, :presence => true
	validates :email, :uniqueness => true

	validates :password, :confirmation => true,
						 :length => { :within => 6...20},
						 :presence => true,
						 :if => :password_required?

	before_save :encrypt_new_password

	def self.authenticate(email,password)
		user = find_by_email(email)
		return user if user && user.authenticated?(password)
	end

	def authenticated?(password)
		self.hashed_password == encrypt(password)
	end

	def self.validate_session(id, session)
		if (id != nil && session != nil)
			user = find_by_id(id)
			if (session == user.session_id)
				return true
			else
				return false
			end
		else 
			return false
		end
	end

	# Support look up methods
	def get_upcoming_lessons
		students = self.students
		lessons = []
		students.each { |student| 
			current = student.get_upcoming_lessons
			if (current.count > 0 && lessons.count == 0)
				lessons = current
			elsif (current.count > 0 && lessons.count > 0)
				lessons = lessons + current
			end
		}
		return lessons.sort_by(&:schedule)
	end

	def get_unresolved_lessons
		students = self.students
		lessons = []
		students.each { |student| 
			current = student.get_unresolved_lessons 
			if (current.count > 0 && lessons.count == 0)
				lessons = current
			elsif (current.count > 0 && lessons.count > 0)
				lessons = lessons + current
			end
		}
		return lessons.sort_by(&:schedule)
	end

	# Utilities
	def get_user_timezone_code
		res = ActiveSupport::TimeZone.us_zones.map(&:name)
		return res[self.timezone]
	end


	# Encryption Methods
	protected
		def encrypt_new_password
			return if password.blank?
			self.hashed_password = encrypt(password)
		end

		def encrypt(string)
			salt = Lament::Application.config.user_salt.dup
			salt << Digest::SHA1.hexdigest(string)
		end

		def password_required?
			hashed_password.blank? || password.present?
		end


end
