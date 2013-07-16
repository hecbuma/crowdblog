module Crowdblog
  class Category < ActiveRecord::Base
    attr_accessible :name

    has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
    belongs_to :parent_category, :class_name => "Category"

    has_many :posts

    def self.top_level
      where(parent_id: nil)
    end
  end
end
