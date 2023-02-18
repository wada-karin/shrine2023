Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
  end

  get 'posts/:post_id/likes' => 'likes#create'
  get 'posts/:post_id/likes/:id' => 'likes#destroy'



root 'posts#index'


end
