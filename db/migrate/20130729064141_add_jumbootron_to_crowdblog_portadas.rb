class AddJumbootronToCrowdblogPortadas < ActiveRecord::Migration
  def change
    add_column :crowdblog_portadas, :jumbotron, :text
  end
end
