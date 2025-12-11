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
  resources :users, only: [:index, :show, :destroy]

  # journal_tag_relations
  resources :journal_tag_relations, only: [:create, :destroy]

  root "journals#index"
end
