Notecards::Application.routes.draw do
 
  devise_for :users do
    get 'login', :to => "devise/sessions#new"
    get 'forgot', :to => "devise/passwords#new"
    get 'logout', :to => "devise/sessions#destroy"
    get 'signup', :to => "devise/registrations#new"
    get 'profile', :to => "devise/registrations#edit"
    get 'resend', :to => "devise/confirmations#new"
  end


  scope ":username", :as => 'user' do 
    resources :cards
    match ':month' => 'cards#month'
    match ':month/:day' => 'cards#day'
  end

  match ':username' => 'static#home', :as => :profile

  root :to => "static#index"

end
