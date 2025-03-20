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
    # @note.img = params[:img]

    if @note.save

      image_data = @note.img
      image_data = image_data.sub('data:image/png;base64,', '')

      File.open(Rails.root.join('public', 'uploads', "#{@note.id}.png"), 'wb') do |file|
        file.write(Base64.decode64(image_data))
        # Rails.logger.debug "Image saved to public/uploads/#{@note.id}.png"
      end

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
    # params.permit(:text, :img)
  end
end
