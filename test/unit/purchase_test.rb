require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase

  def setup

  end

  def teardown
    clean_db()
  end

  test "the truth" do
     assert true
  end

  test "Full Number Price Format" do

  	p = Purchase.new
  	p.price = 1.21
  	p.title = "Beethoven"
  	assert p.save

  	assert(p.price_formatted == '$1.21', "1.21 is NOT formatted correctly")

  end

  
  test "No Cents Price Format" do

  	p = Purchase.new
  	p.price = 1.21
  	p.title = "Beethoven"
  	assert p.save	

  	p.price = 1.00 
  	p.save
  	assert(p.price_formatted == '$1.00', "1.00 is NOT formatted correctly: " << p.price_formatted)	

  end

  test "Trailing Zero Price Format" do

  	p = Purchase.new
  	p.price = 1.21
  	p.title = "Beethoven"
  	assert p.save	

  	p.price = 1.20 
  	p.save
  	assert(p.price_formatted == '$1.20', "1.20 is NOT formatted correctly: " << p.price_formatted)	

  end

end
