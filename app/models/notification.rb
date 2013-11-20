class Notification < ActiveRecord::Base

	validates :email, :presence => true,
                      :format => {:with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, :message => 'address is not valid. Please, fix it.'},
                      :uniqueness => { :case_sensitive => false }

end
