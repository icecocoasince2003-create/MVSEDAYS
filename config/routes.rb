Rails.application.routes.draw do
  # 一時的に追加(本番環境のみ)
  if Rails.env.production?
    get 'setup/run_migrations', to: 'setup#run_migrations'
    get 'setup/run_seeds', to: 'setup#run_seeds'
  end

  devise_for :users

  resources :journals do
    member do
      get :select_museum
      post 'like', to: 'journal_likes#create'
      delete 'unlike', to: 'journal_likes#destroy'
    end
    resources :journal_comments, only: [:create, :destroy]
  end

  resources :museums do
    collection do
      get :search
      get :autocomplete
    end
  end

  # 博物館診断機能
  resources :museum_diagnosis, only: [:new, :create], path: 'museum_diagnosis', controller: 'museum_diagnosis'
  
  get 'my_page', to: 'users#my_page', as: :my_page
  resources :users, only: [:index, :show, :destroy]
  resources :journal_tag_relations, only: [:create, :destroy]

  root "journals#index"
end