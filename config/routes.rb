Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'login',    to: "devise/sessions#new"
    get 'forgot',   to: "devise/passwords#new"
    get 'logout',   to: "devise/sessions#destroy"
    get 'signup',   to: "devise/registrations#new"
    get 'settings', to: "devise/registrations#edit"
    get 'resend',   to: "devise/confirmations#new"
  end

  post 'mailin',    to: 'cards#mailin'
  get 'data',       to: 'cards#data',   as: :data

  scope ":username", as: 'user' do
    resources :cards
    get ':month',       to: 'cards#month',  as: :month,  constraints: { month: /\d{1,2}/ }
    get ':month/:day',  to: 'cards#day',    as: :day,    constraints: { day: /\d{1,2}/, month: /\d{1,2}/ }
  end

  get 'home',           to: 'cards#new',    as: :home
  get 'home/yesterday', to: 'cards#forgot', as: :yesterday

  get ':username',      to: 'cards#index',  as: 'profile'

  root :to => "static#index"
end
