class CreateNotes < ActiveRecord::Migration[8.1]
  def change

    create_table :notes do |t|
      t.string :title
      t.text :details
      t.boolean :completed
      t.timestamps
    end

    # create_table :notes, id: false do |t|
    #   t.string :id, primary_key: true
    #   t.text :content
    #   t.boolean :image_saved
    #   t.timestamps
    # end
  end
end
