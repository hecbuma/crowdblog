module Crowdblog
  class HomeSection < ActiveRecord::Base
    attr_accessible :portada_id, :position, :section_type
    has_many :section_posts
    has_many :posts, :through => :section_posts
  end
end
