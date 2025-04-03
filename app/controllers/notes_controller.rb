class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
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
      redirect_to user_notes_path(Current.user), notice: 'Note was successfully created.'
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
    redirect_to user_notes_path(Current.user), notice: 'Note was successfully deleted.'
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    # Title is now optional, but we still permit it in case it's provided
    params.require(:note).permit(:title, :content, :img)
  end
end
