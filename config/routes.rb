Rails.application.routes.draw do

  controller :sessions do
    get 'signed_in', action: :signed_in
    post 'sign_in', action: :create
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

  scope '/:user_id', as: 'user' do
    controller :notes do
      get    'notes',          action: :index
      get    'notes/new',      action: :new
      post   'notes',          action: :create
      delete 'notes',          action: :destroy_multiple
    end
  end

  controller :user_uploads do
    get 'uploads/:user_id/:filename.png', action: :show, as: :user_upload
  end

  root "static_pages#splash"
end
