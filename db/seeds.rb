# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Create Default Users
User.create(:name => "Corey", :email => "tiltedlistener@gmail.com", :password => "Vat0Natt01")
User.create(:name => "Carrie", :email => "capurcell@gmail.com", :password => "Vat0Natt01")

# Create
Student.create(:name => "Keenan Taco")

# Create default roles
Role.create(:rid => 1, :type =>'user')
Role.create(:rid => 2, :type =>'admin')

# Create default time intervals
TimeInterval.create(:time_code => 1, :time_label => '1 Weeks', :timelength =>604800)
TimeInterval.create(:time_code => 2, :time_label => '2 Weeks', :timelength =>1209600)
TimeInterval.create(:time_code => 3, :time_label => '4 Weeks', :timelength =>2419200)