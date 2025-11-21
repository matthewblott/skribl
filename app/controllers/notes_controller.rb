class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  
  def index
    # @pagy, @notes = pagy(Note.order(created_at: :desc), items: 10)
    @pagy, @notes = pagy(Note.order(created_at: :asc), items: 10)
    
    if turbo_frame_request?
      render partial: "notes/notes_frame", locals: { note_view_models: @notes, pagy: @pagy }
    end
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      redirect_to user_note_path(Current.user, @note), notice: "note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      redirect_to user_note_path(Current.user, @note), notice: "note was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy!
    redirect_to user_notes_path(Current.user), notice: "note was successfully destroyed.", status: :see_other
  end

  private
    def set_note
      @note = Note.find(params.expect(:id))
    end

  def note_params
    params.expect(note: [ :content ])
  end
end

