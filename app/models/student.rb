class Student < ActiveRecord::Base
    include SessionsHelper
	belongs_to :user
	has_many :contacts
	has_many :lessons
	has_many :invoices
	has_many :purchases
	has_many :logs
	
	validates :name, :presence => true

	after_destroy :clean_up

	# Create/adjust/destroy methods
	def clean_up
		lessons = self.get_upcoming_lessons
		lessons.each { |l| l.destroy }
	end

	# Helper methods for lessons
	def get_lessons
		return self.lessons
	end

	def get_unpaid_lessons
		return self.lessons.where(:paid => false).to_a
	end

	def get_unresolved_lessons 
		self.lessons.where("schedule < ? AND resolved = ?", DateTime.now, false)
	end

	def get_upcoming_lessons
		self.lessons.where("schedule > ?", DateTime.now).order('schedule asc').limit(10)
	end

end
