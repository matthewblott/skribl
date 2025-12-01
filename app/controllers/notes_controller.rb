class NotesController < ApplicationController
  
  def index
    if params[:note_deleted] == 1.to_s
      flash.now[:notice] = "Note was successfully deleted."
    end
  
    @pagy, @notes = pagy_countless(Note.recent_first, items: 20)
    
    if turbo_frame_request?
      render partial: "notes/notes_frame", locals: { notes_view_models: @notes, pagy: @pagy }
    end
  end

  def new
    if params[:from_sign_in] == 1.to_s 
      flash.now[:notice] = "Signed in successfully"
    end
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
  
    ImageToFileJob.perform_later(Current.user.id, @note.id, @note.img) # if @note.persisted?
  
    if @note.save
      flash.now[:notice] = "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy_multiple
    @deleted_ids = Array(params[:ids])

    Note.where(id: params[:ids]).destroy_all

    @deleted_ids.each do |id|
      DeleteImageJob.perform_later(Current.user.id, id)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_notes_path(Current.user), notice: "Deleted" }
    end

  end

  def destroy_all
    Note.destroy_all 
    Current.user.reset
  end 

  private

  def note_params
    params.require(:note).permit(:content, :img)
  end
end
