class AddOpinionToCrowdblogPost < ActiveRecord::Migration
  def change
    add_column :crowdblog_posts, :opinion, :boolean
  end
end
