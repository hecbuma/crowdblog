class CreateCrowdblogBanners < ActiveRecord::Migration
  def change
    create_table :crowdblog_banners do |t|
      t.string :image
      t.timestamp :start_date
      t.timestamp :end_date
      t.text :html_code
      t.text :url
      t.string :space

      t.timestamps
    end
  end
end
