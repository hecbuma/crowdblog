class AddPositionToCrowdblogSectionPosts < ActiveRecord::Migration
  def change
    add_column :crowdblog_section_posts, :position, :integer
  end
end
