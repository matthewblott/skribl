class OldNotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    if params[:note_deleted] == 1.to_s
      flash.now[:notice] = "Note was successfully deleted."
    end

    @pagy, @notes = pagy_countless(Note.recent_first, items: 20)

    if turbo_frame_request?
      render partial: "notes/notes_frame", locals: { notes: @notes, pagy: @pagy }
    end

  end

  def show
  end

  def new
    if params[:from_sign_in] == 1.to_s 
      flash.now[:notice] = "Signed in successfully"
    end
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    # ImageToFileJob.perform_later(Current.user.id, @note.id, @note.img) # if @note.persisted?

    if @note.save
      flash.now[:notice] = "Note was successfully created."

      respond_to do |format|
        format.turbo_stream
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

    redirect_to user_notes_path(Current.user, note_deleted: 1), format: :html

  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:content, :img)
  end
end
