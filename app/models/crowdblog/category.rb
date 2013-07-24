module Crowdblog
  class Category < ActiveRecord::Base
    attr_accessible :name, :footer, :header

    has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
    belongs_to :parent_category, :class_name => "Category"

    has_many :posts

    def self.top_level
      where(parent_id: nil)
    end

    def self.only_header
      where(header: true)
    end

    def self.only_footer
      where(footer: true)
    end
  end
end
