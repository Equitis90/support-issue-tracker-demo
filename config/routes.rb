Rails.application.routes.draw do
  root :to => 'ticket#index'

  post "create_ticket_post" => "ticket#create_ticket_post"
  get "search_ticket" => "ticket#search_ticket"
  get "ticket" => "ticket#ticket"
  post "ticket_add_message_post" => "ticket#ticket_add_message_post"
end
