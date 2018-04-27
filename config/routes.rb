Rails.application.routes.draw do
  resources :feeds

  resources :posts do 
    collection do 
	  post :confirm
	end 
  end 

  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :favorites, only: [:create, :destroy]
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
