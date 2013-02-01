class CreateCrowdblogPortadas < ActiveRecord::Migration
  def change
    create_table :crowdblog_portadas do |t|
      t.integer :breaking_news
      t.date :publication

      t.timestamps
    end
  end
end
