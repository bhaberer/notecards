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
    match ':month' => 'cards#month',      :as => :month,  :constraints => { :month => /\d{1,2}/ }
    match ':month/:day' => 'cards#day',   :as => :day,    :constraints => { :day => /\d{1,2}/, :month => /\d{1,2}/ }
  end

  match 'home' => 'cards#new'

  match ':username' => 'cards#index', :as => 'profile' 

  root :to => "static#index"

  # Hack to allow custome 404 partial, since rails doesn't let me override RoutingError atm
  match '*a', :to => 'static#notfound'
end
