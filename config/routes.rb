Track::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  resources :issues, path: '/', only: [:show, :new, :create, :update] do
    collection do
      get 'issues/:scope', action: :index, as: :scoped
      post :search
    end
  end

  root to: 'issues#new'

end
