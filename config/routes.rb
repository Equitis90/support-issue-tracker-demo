Rails.application.routes.draw do
  root :to => 'ticket#index'

  post "create_ticket_post" => "ticket#create_ticket_post"
end
