Rails.application.routes.draw do
    namespace :api do
        get 'users', to: 'users#index'
        post 'users', to: 'users#create'
    end
end
