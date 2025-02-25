class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      Current.session = @session
      Current.user = user

      begin
        # Initialize the user's notes database
        Note.set_database_connection(user)
        redirect_to user_notes_path(user), notice: "Signed in successfully"
      rescue => e
        # If database setup fails, clean up the session
        @session.destroy
        cookies.delete(:session_token)
        Current.session = nil
        Current.user = nil
        redirect_to sign_in_path, alert: "Error setting up user data. Please try again."
      end
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session.destroy; redirect_to(sessions_path, notice: "That session has been logged out")
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
