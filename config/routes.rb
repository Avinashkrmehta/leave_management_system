Rails.application.routes.draw do
	devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }
	resources :leaves
  devise_scope :user do
    authenticated :user do
       get '/users/sign_out' => 'devise/sessions#destroy'
       root 'leaves#index', as: :authenticated_root
    end
    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end	
end