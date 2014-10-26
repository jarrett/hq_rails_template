Rails.application.routes.draw do
  root 'static#home'
  
  get    'login', to: 'user_sessions#new', as: 'login'
  post   'login', to: 'user_sessions#create'
  get    'logout', to: 'user_sessions#destroy', as: 'logout'
  
  get    'join', to: 'users#new', as: 'join'
  post   'join', to: 'users#create'
  
  get    'confirm-email/:token', to: 'users#confirm_email', as: 'confirm_email'
  
  get    'account', to: 'users#edit', as: 'account'
  patch  'account', to: 'users#update'
end
