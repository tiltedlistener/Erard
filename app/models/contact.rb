class Contact < ActiveRecord::Base
	after_initialize :default_values
  
	belongs_to :student
	validates :name, :presence => true
	validates :email, :presence => true,
                      :format => {:with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => 'address is not valid. Please, fix it.'},
                      :uniqueness => { :case_sensitive => false }

    private
      def default_values
        self.billable ||= false
      end
end
