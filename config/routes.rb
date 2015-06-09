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
end
