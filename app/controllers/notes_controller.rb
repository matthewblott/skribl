class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = Note.all
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

    if @note.save
      redirect_to user_note_path(Current.user, @note), notice: 'Note was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      respond_to do |format|
        format.html { redirect_to user_note_path(Current.user, @note), notice: 'Note was successfully updated.' }
        format.turbo_stream { redirect_to user_note_path(Current.user, @note), notice: 'Note was successfully updated.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to user_notes_path(Current.user), notice: 'Note was successfully deleted.' }
      format.turbo_stream { redirect_to user_notes_path(Current.user), notice: 'Note was successfully deleted.' }
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
