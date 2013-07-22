class AddVlogToCrowdblogPost < ActiveRecord::Migration
  def change
    add_column :crowdblog_posts, :vlog, :boolean
  end
end
