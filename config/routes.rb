Rails.application.routes.draw do
  devise_for :users
  
  resources :journals do
    member do
      get :select_museum
      # いいね機能
      post 'like', to: 'journal_likes#create'
      delete 'unlike', to: 'journal_likes#destroy'
    end

    # コメント機能
    resources :journal_comments, only: [:create, :destroy]
  end
  
  resources :museums do
    collection do
      get :search
      get :autocomplete
    end
  end
  
  # マイページルート
  get 'my_page', to: 'users#my_page', as: :my_page

  # ユーザー管理ルート
  resources :users, only:[:index,:show,:destroy]

  # tweet_tag_relations → journal_tag_relations
  resources :journal_tag_relations, only: [:create, :destroy]
  
  root "journals#index"
end
# Rails.application.routes.draw do
#   devise_for :users
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Render dynamic PWA files from app/views/pwa/*
#   get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
#   get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

#   # 日記関連ルート
#   resources :journals do
#     collection do
#       get :select_museum # 博物館選択ページ
#     end
#   end
#   root 'journals#index'

#   get 'journals/new' => 'journals#new'
#   # get 'journals/:id' => 'journals#show', as: 'journal'
#   patch 'journals/:id' => 'journals#update'
#   # get 'journals/:id/edit' => 'journals#edit', as: 'edit_journal'

#   get 'users' => 'users#index'
#   delete 'users/sign_out' => 'devise/sessions#destroy'
#   # Defines the root path route ("/")
#   # root "posts#index"

#   # 博物館関連ルート
#   resources :museums, only: [:index, :show] do
#     collection do
#       get :search
#       get :autocomplete
#     end
#   end
# end
