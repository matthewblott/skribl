class NotesController < ApplicationController
  include Pagy::Method
  before_action :set_note, only: %i[ destroy ]

  def index
    @pagy, @notes = pagy(Note.recent_first, items: 20)
    if turbo_frame_request?
      render partial: "notes/notes_frame", locals: { note_view_models: @notes, pagy: @pagy }
    else
      render :index
    end
  end

  def new
    @note = Note.new
  end

  def legacy_new 
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      # redirect_to user_notes_path(Current.user), notice: "Note was successfully created."
      redirect_to user_notes_path(Current.user)
    else
      render :new, status: :unprocessable_content
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
      params.expect(note: [ :content, :image_saved ])
    end
end
