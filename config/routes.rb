Rails.application.routes.draw do

  # get "signed_in", to: "sessions#signed_in"
  # post "sign_in", to: "sessions#create"
  # get  "sign_in_success", to: "sessions#sign_in_success"

  # get "send_otp", to: "sessions#send_otp"
  # post "validate_otp", to: "sessions#validate_otp"
  # get "enter_otp", to: "sessions#enter_otp"

  # resource :sessions, only: [:destroy] do
  # end

  controller :sessions do
    get 'signed_in', action: :signed_in
    get 'sign_in', action: :create
    get 'sign_in_success', action: :sign_in_success

    get 'send_otp', action: :send_otp
    post 'validate_otp', action: :validate_otp
    get 'enter_otp', action: :enter_otp

    delete 'sessions', action: :destroy
  end

  controller :settings do
    get 'settings', action: :index
    delete 'settings', action: :destroy
    post 'download_images', action: :download_images
  end

  controller :static_pages do
    get 'terms',   action: :terms
    get 'privacy',    action: :privacy
    get 'support',    action: :support
  end

  # scope '/:user_id', as: 'user' do
  #   resources :notes do
  #     delete '/', action: :destroy_multiple, on: :collection
  #   end
  # end

  scope '/:user_id', as: 'user' do
    controller :notes do
      get    'notes',          action: :index
      get    'notes/new',      action: :new
      post   'notes',          action: :create
      # get    'notes/:id',      action: :show
      # get    'notes/:id/edit', action: :edit
      # patch  'notes/:id',      action: :update
      # put    'notes/:id',      action: :update
      # delete 'notes/:id',      action: :destroy

      # collection action
      delete 'notes',          action: :destroy_multiple
    end
  end

  # get "/uploads/:user_id/:filename.png", to: "user_uploads#show", as: :user_upload

  controller :user_uploads do
    get 'uploads/:user_id/:filename.png', action: :show, as: :user_upload
  end

  root "splash#index"
end
