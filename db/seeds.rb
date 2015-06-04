# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(:login => "admin", :password => '123', :admin => true, :username => 'admin')

Department.create!(title: 'General issues')

departments_list = [
    "Second department",
    "Third department",
    "Fourth department",
    "Fifth department"
]

ticket_status_list = [
    'Waiting for Staff Response',
    'Waiting for Customer',
    'On Hold',
    'Cancelled',
    'Completed'
]

departments_list.each do |title|
  Department.create!(title: title)
end

ticket_status_list.each do |status_name|
  TicketStatus.create!(title: status_name)
end