class Purchase < ActiveRecord::Base
  belongs_to :student
  belongs_to :user

  before_save :trim_price

  validates :title, :price, :presence => true

  def price_formatted
  	return '$' << sprintf("%.2f",self.price)
  end

  protected
  	def trim_price
  		self.price = self.price.round(2)
  	end

end
