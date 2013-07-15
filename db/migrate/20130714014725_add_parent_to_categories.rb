class AddParentToCategories < ActiveRecord::Migration
  def change
    add_column :crowdblog_categories, :parent_id, :integer
  end
end
