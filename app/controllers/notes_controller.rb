class NotesController < ApplicationController
  include Pagy::Backend
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # @pagy, @order_items = pagy(OrderItem.includes(:product).by_order(order_id), items: count)
  # scope :by_order, -> (order_id) { where(order_id: order_id) }

  def index
    # @notes = Note.all
    @notes = Note.recent_first
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
      redirect_to user_notes_path(Current.user), notice: 'Note was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      respond_to do |format|
        format.html { redirect_to user_notes_path(Current.user), notice: 'Note was successfully updated.' }
        format.turbo_stream { redirect_to user_notes_path(Current.user), notice: 'Note was successfully updated.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to user_notes_path(Current.user), notice: 'Note was successfully deleted.' }
      # format.turbo_stream
      format.turbo_stream { redirect_to user_notes_path(Current.user), notice: 'Note was successfully deleted.' }

    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    # Title is now optional, but we still permit it in case it's provided
    params.require(:note).permit(:title, :content)
  end
end
