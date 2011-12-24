Notecards::Application.routes.draw do
 
  scope ":username", :as => 'user' do 
    match ':month' => 'cards#month'
    match ':month/:day' => 'cards#day'
    resources :cards
  end

  match ':username' => 'static#home', :as => :profile

  devise_for :users

  root :to => "static#index"

end
