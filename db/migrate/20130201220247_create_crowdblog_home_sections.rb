class CreateCrowdblogHomeSections < ActiveRecord::Migration
  def change
    create_table :crowdblog_home_sections do |t|
      t.integer :position
      t.integer :portada_id
      t.string :type

      t.timestamps
    end
  end
end
