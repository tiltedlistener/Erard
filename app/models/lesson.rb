class Lesson < ActiveRecord::Base
  include SessionsHelper
  after_initialize :default_values

  belongs_to :student

  validates :schedule, :presence => true
  # Default is false for paid
  
  def schedule_in_user_zone(zone)
  	return self.schedule.in_time_zone(zone)
  end

  private
      def default_values
        self.resolved ||= false
        self.paid ||= false
      end

end
