class NotesController < ApplicationController
  
  def index
    @pagy, @notes = pagy_countless(Note.recent_first, items: 20)
    
    if turbo_frame_request?
      render partial: "notes/notes_frame", locals: { notes_view_models: @notes, pagy: @pagy }
    end
  end

  def new
    if params[:from_sign_in] == 1.to_s 
      flash.now[:notice] = "Signed in successfully"
    end
    # @note = Note.new
  end

  # def create
  #   @note = Note.new(note_params)
  # 
  #   ImageToFileJob.perform_later(Current.user.id, @note.id, @note.img) # if @note.persisted?
  # 
  #   if @note.save
  #     flash.now[:notice] = "Note was successfully created."
  #     redirect_to new_user_note_path(Current.user)
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  def create
    @note = Note.new(note_params)

    # respond_to do |format|
    #   if @note.save
    #     # ImageToFileJob.perform_later(Current.user.id, @note.id, @note.img)
    #     ImageToFileJob.perform_now(Current.user.id, @note.id, @note.img)
    #     flash.now[:notice] = "Note was successfully created."
    #     @note = Note.new
    #     format.turbo_stream
    #   else
    #     flash.now[:notice] = "There was an error, try again."
    #    format.turbo_stream
    #   end
    # end

    respond_to do |format|
      if @note.save
        begin
          ImageToFileJob.perform_now(Current.user.id, @note.id, @note.img)

          flash.now[:notice] = "Note was successfully created."
          @note = Note.new
        rescue => e
          # Job failed – treat as an error
          flash.now[:alert] = "Note saved, but processing failed: #{e.message}"
        end
      else
        flash.now[:alert] = "There was an error, try again."
      end

      format.turbo_stream
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
      format.html {
        flash[:notice] = "Note was successfully deleted."
        redirect_to user_notes_path(Current.user)
      }
    end

  end

  private

  def note_params
    params.require(:note).permit(:content, :img)
  end
end
