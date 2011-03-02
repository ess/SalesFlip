Salesflip::Application.routes.draw do
  devise_for :users

  root :to => 'pages#index'

  match 'profile', :to => 'users#profile'

  match 'help(/:action)(/:locale)', :to => "help"
  match "external_updates/user", to: "external_updates#update_user", as: "user_external_updates"

  resources :users, :comments, :tasks, :deleted_items,
    :searches, :invitations, :emails, :opportunities, :campaigns

  resources :infomail_templates

  resources :leads do
    resources :infomails, :only => [:new, :create]

    member do
      get :finish
      get :convert
      put :promote
      put :reject
    end

    collection do
      get :export
      get :next
    end
  end
  resources :lead_imports

  resources :contacts do
    get :export, :on => :collection
  end

  resources :accounts do
    get :export, :on => :collection
  end

  namespace :administration do
    root :to => 'pages#index'
    resources :leads do
      collection do
        put :assignee
        put :campaign
        put :rating
        put :source
        put :status, :to => "leads#update_status"
      end
    end

    resources :opportunity_stages do
      get :confirm_delete, :on => :member
    end
  end
end
