Notecards::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    get 'login', :to => "devise/sessions#new"
    get 'forgot', :to => "devise/passwords#new"
    get 'logout', :to => "devise/sessions#destroy"
    get 'signup', :to => "devise/registrations#new"
    get 'settings', :to => "devise/registrations#edit"
    get 'resend', :to => "devise/confirmations#new"
  end

  match 'mailin' => 'cards#mailin', :via => :post

  scope ":username", :as => 'user' do
    resources :cards
    match ':month' => 'cards#month',      :as => :month,  :constraints => { :month => /\d{1,2}/ }
    match ':month/:day' => 'cards#day',   :as => :day,    :constraints => { :day => /\d{1,2}/, :month => /\d{1,2}/ }
  end

  match 'home' => 'cards#new', :as => 'home'
  match 'home/yesterday' => 'cards#forgot', :as => 'yesterday'

  match ':username' => 'cards#index', :as => 'profile'

  root :to => "static#index"

  # Hack to allow custom 404 partial, since rails doesn't let me override RoutingError atm
  match '*a', :to => 'static#notfound'
end
