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

    controller :settings do
      get "settings", action: :show, as: :settings
    end
  end

  controller :registrations do
    get  "register",        action: :new,       as: :registration
    post "register/send",   action: :send_code, as: :registration_send_code
    get  "register/verify", action: :verify,    as: :registration_verify_code
    post "register/verify", action: :create,    as: :registration_create
  end

  controller :guest_sessions do
    post   "session/guest",  action: :create,   as: :guest_session_create
  end

  controller :user_security do
    get  "security",        action: :new,       as: :security
    post "security/send",   action: :send_code, as: :security_send_code
    get  "security/verify", action: :verify,    as: :security_verify_code
    post "security/verify", action: :create,    as: :security_create
  end

  controller :sessions do
    get  "session",            action: :new,       as: :session
    post "session/send",       action: :send_code, as: :session_send_code
    get  "session/verify",     action: :verify,    as: :session_verify_code
    post "session/verify",     action: :create,    as: :session_create
    delete "session/sign_out", action: :destroy,   as: :session_destroy
  end

  controller :static_pages do
    get "about", action: :about
  end

  root "static_pages#home"

end
