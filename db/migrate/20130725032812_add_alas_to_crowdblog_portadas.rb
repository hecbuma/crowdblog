class AddAlasToCrowdblogPortadas < ActiveRecord::Migration
  def change
    add_column :crowdblog_portadas, :plumas_author, :string
    add_column :crowdblog_portadas, :plumas_title, :string
    add_column :crowdblog_portadas, :plumas, :text
    add_column :crowdblog_portadas, :plumas_on_top, :boolean
  end
end
