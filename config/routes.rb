Notecards::Application.routes.draw do
 
  devise_for :users

  scope ":username", :as => 'user' do 
    match ':month' => 'cards#month'
    match ':month/:day' => 'cards#day'
    resources :cards
  end

  match ':username' => 'static#home', :as => :profile

  root :to => "static#index"

end
