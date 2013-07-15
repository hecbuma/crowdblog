module Crowdblog
  class HomeSection < ActiveRecord::Base
    attr_accessible :portada_id, :position, :section_type, :section_posts, :section_posts_attributes
    has_many :section_posts, :dependent => :destroy
    has_many :posts, :through => :section_posts
    accepts_nested_attributes_for :section_posts, allow_destroy: true
  end
end
