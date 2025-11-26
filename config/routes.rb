Rails.application.routes.draw do
  get "signed_in", to: "status#signed_in"
  get 'status', to: 'status#status'

  post "sign_in", to: "sessions#create"

  get  "sign_in_success", to: "sessions#sign_in_success"

  get "send_otp", to: "sessions#send_otp"
  post "validate_otp", to: "sessions#validate_otp"
  get "enter_otp", to: "sessions#enter_otp"

  # post "sign_up", to: "registrations#create"
  # resources :sessions, only: [:index, :show, :destroy]

  resource :sessions, only: [:new, :show, :destroy] do
    get :otp
  end

  get "settings", to: "settings#index"
  delete "settings", to: "settings#destroy"

  scope '/:user_id', as: 'user' do
    resources :notes
  end

  get "/uploads/:user_id/:filename.png", to: "user_uploads#show", as: :user_upload

  root "splash#index"
end
