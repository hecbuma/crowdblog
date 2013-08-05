class AddShortUrlToCrowdblogPosts < ActiveRecord::Migration
  def change
    add_column :crowdblog_posts, :short_url, :string
  end
end
