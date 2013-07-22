class CreateCrowdblogQuoteNotes < ActiveRecord::Migration
  def change
    create_table :crowdblog_quote_notes do |t|
      t.string :quote
      t.string :author
      t.string :charge
      t.integer :portada_id
      t.integer :post_id

      t.timestamps
    end
  end
end
