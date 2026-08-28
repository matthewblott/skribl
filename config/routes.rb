Rails.application.routes.draw do

  scope "/:user_id", constraints: { user_id: /\d+/ }, as: :user do
    controller :notes do
      get    "notes",          action: :index,            as: :notes
      get    "notes/new",      action: :new,              as: :new_note
      post   "notes",          action: :create,           as: :notes_create
      delete "notes",          action: :destroy_multiple, as: :notes_destroy_multiple

      get    "notes/:id",      action: :show,             as: :note
      get    "notes/:id/edit", action: :edit,             as: :note_edit
      patch  "notes/:id",      action: :update,           as: :note_update
      delete "notes/:id",      action: :destroy,          as: :note_destroy
    end

    controller :account do
      get "account", action: :index, as: :account
      get  "account/new",        action: :new,       as: :new_account
      post "account/send",       action: :send_code, as: :account_send_code
      get  "account/verify",     action: :verify,    as: :account_verify_code
      post "account/verify",     action: :create,    as: :account_create
    end

  end

  controller :auth do
    get  "auth",            action: :new,       as: :auth
    post "auth/send",       action: :send_code, as: :auth_send_code
    get  "auth/verify",     action: :verify,    as: :auth_verify_code
    post "auth/verify",     action: :create,    as: :auth_create
    delete "auth/sign_out", action: :destroy,   as: :auth_destroy
  end

  controller :guest_sessions do
    post   "session/guest",  action: :create,   as: :guest_session_create
  end

  controller :static_pages do
    get "about", action: :about
  end

  root "static_pages#home"

end
