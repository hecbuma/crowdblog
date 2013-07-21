class AddPoliceNoteModel < ActiveRecord::Migration
  def change
    create_table :crowdblog_police_notes do |t|
      t.string :title
      t.string :balazo
      t.integer :portada_id

      t.timestamps
    end
  end
end
