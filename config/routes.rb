Salesflip::Application.routes.draw do
  devise_for :users

  root :to => 'pages#index'

  match 'profile', :to => 'users#profile'

  resources :users, :comments, :tasks, :deleted_items,
    :searches, :invitations, :emails

  resources :leads do
    member do
      get :convert
      put :promote
      put :reject
    end
    get :export, :on => :collection
  end

  resources :contacts do
    get :export, :on => :collection
  end

  resources :accounts do
    get :export, :on => :collection
    get :did_you_mean, :on => :collection
  end
end
