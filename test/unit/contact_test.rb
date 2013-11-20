require 'test_helper'

class ContactTest < ActiveSupport::TestCase

  def setup
    @u = users(:one)
    
    @s = students(:one)
    @s.user_id = @u.id
    @s.save
  end

  def teardown
  	clean_db()
  end

end
