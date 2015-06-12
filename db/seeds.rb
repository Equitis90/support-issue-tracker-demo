# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(:login => "admin", :password => '123', :admin => true, :username => 'admin')

Department.create!(title: 'General issues')

tickets_list = [
    ['ben', 'ben@mail.com', 'text', '1'],
    ['mike', 'mike@mail.com', 'text', '2'],
    ['pete', 'pete@mail.com', 'text', '3'],
    ['jon', 'jon@mail.com', 'text', '4'],
    ['jain', 'jain@mail.com', 'text', '5']
]

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

users_list = [
    ['eddard', 'Ned Stark', 'winter_is_coming'],
    ['bob', 'Robert Baratheon', 'ours_is_the_fury'],
    ['dany', 'Daenerys Targarien', 'fire_and_blood'],
    ['tywin', 'Tywin Lannister', 'hear_me_roar']
]

departments_list.each do |title|
  Department.create!(title: title)
end

users_list.each_with_index do |user, index|
  dept_id = Department.where(title: departments_list[index]).first.id
  User.create!(login: user[0], username: user[1], department_id: dept_id, password: user[2])
end

ticket_status_list.each do |status_name|
  TicketStatus.create!(title: status_name)
end

wait_for_staff_status = TicketStatus.where(title: 'Waiting for Staff Response').first.try(:id)

ActiveRecord::Base.skip_callbacks = true

tickets_list.each do |ticket|
    ticket_cr = Ticket.create!(department_id: ticket[3], ticket_status_id: wait_for_staff_status,
                            creator_name: ticket[0], creator_email: ticket[1])
    TicketMessage.create!(ticket_id: ticket_cr.id, text: ticket[2])
end

ActiveRecord::Base.skip_callbacks = false