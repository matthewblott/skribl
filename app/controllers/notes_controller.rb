class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to user_note_path(Current.user, @note), notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @note.update(note_params)
      redirect_to user_note_path(Current.user, @note), notice: "Note was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @note.destroy!
    redirect_to user_notes_path(Current.user), notice: "Note was successfully destroyed.", status: :see_other
  end

  private
    def set_note
      @note = Note.find(params.expect(:id))
    end

    def note_params
      params.expect(note: [ :title, :details, :completed ])
    end
end
