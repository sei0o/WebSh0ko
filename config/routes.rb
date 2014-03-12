Webshoko::Application.routes.draw do
	
	root "fixed_pages#index"
  resources :fixed_pages, only: [:index, :help]
  
  get 'signin' => 'sessions#create'
  get 'signout' => 'sessions#_delete'
  
	scope '/book', controller: 'books', as: 'book' do
		get 'create', 'edit', 'search', 'lend', 'return'
		# API
		post '_lend', '_return', '_search', '_show', '_create', '_edit'
		delete ':id/_delete' => 'books#_delete', as: 'delete'
		get ':id' => 'books#show', as: ''
		get '' => 'books#index', as: 'index'
	end
	
	scope '/user', controller: 'users', as: 'user' do
		get 'signup' => 'users#create'
		get 'search'
		post '_create', '_edit', '_search', '_show'
		delete '_delete'
		get ':account' => 'users#show'
		get ':account/edit' => 'users#edit', as: 'edit'
		get ':account/icon' => 'users#icon', as: 'icon'
		get ':account/authorization' => "roles#authorization", as:"auth"
		post ':account/_authorization' => "roles#_authorization", as:"_auth"
		delete ':account/_delete' => 'users#_delete', as: 'delete'
		
		get '' => 'users#index', as: 'index'
	end
	
	scope '/sessions', controller: "sessions", as: "session" do
		post '_create'
	end
	
	scope '/settings', controller: 'settings', as: 'set' do
		get 'theme'
		scope '/role', controller: "roles", as: "role" do
			get "create","show", "edit"
			post "_create", "_show", "_edit"
			delete "_delete"
		end
	end
	
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
