Rails.application.routes.draw do
  devise_for :users

  resource :sessions, :only => [:new, :create, :destroy]

  namespace :api,defaults: {format: :json} do
    namespace :v1 do
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        delete "log_out", to: "sessions#destroy"
        post "facebook", to: "users#facebook"
      end
      
    end
  end
end
