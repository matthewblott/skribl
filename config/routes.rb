Rails.application.routes.draw do
  get "signed_in", to: "sessions#signed_in"

  post "sign_in", to: "sessions#create"
  get  "sign_in_success", to: "sessions#sign_in_success"

  get "send_otp", to: "sessions#send_otp"
  post "validate_otp", to: "sessions#validate_otp"
  get "enter_otp", to: "sessions#enter_otp"

  resource :sessions, only: [:destroy] do
  end

  get "settings", to: "settings#index"
  delete "settings", to: "settings#destroy"

  scope '/:user_id', as: 'user' do
    resources :notes do
      delete '/', action: :destroy_multiple, on: :collection
    end
  end

  get "/uploads/:user_id/:filename.png", to: "user_uploads#show", as: :user_upload

  root "splash#index"
end
