class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    if params[:note_deleted] == 1.to_s
      flash.now[:notice] = "Note was successfully deleted."
    end

    @pagy, @notes = pagy(Note.recent_first)

  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    ImageToFileJob.perform_later(Current.user.id, @note.id, @note.img) # if @note.persisted?

    if @note.save
      flash.now[:notice] = "Note was successfully created."
      # redirect_to new_user_note_path

      respond_to do |format|
        format.turbo_stream
        # format.html { redirect_to notes_path, notice: "Note created." }
        # format.turbo_stream { render turbo_stream: turbo_stream.replace("new_note", partial: "notes/form", locals: { note: @note }) }

      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      redirect_to user_notes_path(Current.user), notice: 'Note was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    flash[:notice] = "Note was successfully deleted."
    session[:deletion_notice] = flash[:notice]
    DeleteImageJob.perform_later(Current.user.id, @note.id)

    # redirect_to user_notes_path(Current.user)
    redirect_to user_notes_path(Current.user, note_deleted: 1)

  end

  # def destroy
  #   @note.destroy
  #   flash.now[:notice] = "Note was successfully deleted."
  #   session[:deletion_notice] = "Note was successfully deleted."
  #
  #   DeleteImageJob.perform_later(Current.user.id, @note.id)
  #   
  #   respond_to do |format|
  #     format.html { redirect_to user_notes_path(Current.user) }
  #     format.turbo_stream
  #   end
  # end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    # Title is now optional, but we still permit it in case it's provided
    params.require(:note).permit(:title, :content, :img)
  end
end
