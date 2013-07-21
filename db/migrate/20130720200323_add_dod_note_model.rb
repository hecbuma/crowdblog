class AddDodNoteModel < ActiveRecord::Migration
  def change
    create_table :crowdblog_dod_notes do |t|
      t.string :title
      t.string :balazo
      t.integer :portada_id

      t.timestamps
    end
  end
end
