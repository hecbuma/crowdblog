class AddPostIdToCrowdblogPoliceNotes < ActiveRecord::Migration
  def change
    add_column :crowdblog_police_notes, :post_id, :integer
  end
end
