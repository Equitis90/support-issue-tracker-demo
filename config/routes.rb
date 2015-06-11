Rails.application.routes.draw do
  root :to => 'ticket#index'

  post "create_ticket_post" => "ticket#create_ticket_post"
  get "search_ticket" => "ticket#search_ticket"
  get "ticket" => "ticket#ticket"
  post "ticket_add_message_post" => "ticket#ticket_add_message_post"
  get "admin" => "admin#admin"
  post "log_in_post" => "admin#log_in_post"
  get "tickets" => "admin#tickets"
  post "log_out_post" => "admin#log_out_post"
  get "get_json_tickets" => "admin#get_json_tickets"
  get "tickets_list_partial" => "admin#tickets_list_partial"

  get "users" => "admin#users"
  post "create_user" => "admin#create_user"
  get "get_user" => "admin#get_user"
  post "edit_user" => "admin#edit_user"
  post "delete_user" => "admin#delete_user"

  get "departments" => "admin#departments"
  post "create_department" => "admin#create_department"
  get "get_department" => "admin#get_department"
  post "edit_department" => "admin#edit_department"
  post "delete_department" => "admin#delete_department"

  get "ticket_statuses" => "admin#ticket_statuses"
  post "create_ticket_status" => "admin#create_ticket_status"
  get "get_ticket_status" => "admin#get_ticket_status"
  post "edit_ticket_status" => "admin#edit_ticket_status"
  post "delete_ticket_status" => "admin#delete_ticket_status"
end
