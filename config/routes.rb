CidadeVc::Application.routes.draw do

  resources :items

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  resources :countries

  resources :states



  post '/rate' => 'rater#create', :as => 'rate'



  # Devise

  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

  devise_scope :user do
    get 'sign_up', to: 'devise/registrations#new', as: :registrar
    get 'sign_in', to: 'devise/sessions#new', as: :entrar
    get 'sign_out', to: 'devise/sessions#destroy', as: :sair
    get 'account/edit', to: 'devise/registrations#edit', as: 'conta_edit'
  end


  scope "(:locale)", locale: /en|pt-BR/ do

    root to: 'welcome#index', as: :welcome

    resources :items do
      get :schedule, on: :member
      get :fulldescription, to: 'items#full_description'
    end

    resources :events, controller: 'items', type: 'Event' do
      get :schedule, on: :member
      get :fulldescription, to: 'events#full_description'
    end

    resources :activities, controller: 'items', type: 'Activity' do
      get :schedule, on: :member
      get :fulldescription, to: 'activities#full_description'
    end

    # Account
    get 'user/:id/account', to: 'accounts#edit', as: :user_account
    match 'account/update/:id', to: 'accounts#update', via: :put, as: :account_update





    get "bussola/city"
    get "bussola/neighborhood"
    post "bussola/selecionado"




    # /myneighborhood -> filtra os eventos por bairro para o current_user
    get 'myneighborhood/', to: 'newsfeed#myneighborhood', as: :my_neighborhood_events

    # /myagenda -> filtra os eventos da minha agenda
    get 'user/:user/agenda/', to: 'newsfeed#agenda', as: :agenda


    # Notifications
    get "notify/bell"
    get "notify/newsfeed"



    resources :subcategories

    resources :categories

    resources :cities

    resources :neighborhoods

    resources :places

    resources :levels

    resources :users, except: :show

    resources :invites

    resources :weeks

    resources :prices

    # /feedback
    resources :feedbacks

    # /persona
    resources :personas

    resources :tips


    get 'user/:id/events', to: 'profiles#events', as: :user_events
    get 'user/:id/', to: 'users#show', as: :show_user

    # /city
    get 'newsfeed', to: 'newsfeed#index', as: :root
    get ':city', to: 'newsfeed#city', as: :newsfeed_city
    get ':city/today', to: 'newsfeed#today', as: :newsfeed_city_today
    get ':city/persona=(:personas)', to: 'newsfeed#persona', as: :newsfeed_city_persona
    get ':city/category=(:categories)', to: 'newsfeed#category', as: :newsfeed_city_category
    get ':city/:neighborhood', to: 'newsfeed#neighborhood', as: :newsfeed_city_neighborhood


    # AJAX ------------------------------------------

    # Complete description of event on show
    get 'events/:event/fulldescription', to: 'events#full_description', as: 'full_description'

    # Aprove event to newsfeed
    match 'items/aprove/:id', to: 'items#aprove', via: :put, as: 'item_aprove'

    # Friendship routes
    get "friendships/request", to: "friendships#request_friendship", as: :friend_request
    get "friendships/accept", to: "friendships#accept_friendship", as: :friend_accept
    get "friendships/destroy", to: "friendships#destroy_friendship", as: :friend_destroy

    # Send invite to users
    get 'invites/send/:key', to: 'invites#send_invite', as: 'send_invite'


    # Tips on events
    get "tips/create"
    get "tips/destroy"

  end







  # torna possivel "redirects" para root_path
  # root :controller => 'static', :action => '/' 

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
