class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])

    if user.nil?
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
      return
    end

    @session = user.sessions.create!

    if Rails.env.test?
      cookies[:session_token] = @session.id
    else
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
    end

    Current.session = @session
    Current.user = user

    Note.set_database_connection(user)
    redirect_to user_notes_path(user), notice: "Signed in successfully"
  end

  def destroy
    @session.destroy
    redirect_to sessions_path, notice: "That session has been logged out"
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end