module Crowdblog
  class HomeSection < ActiveRecord::Base
    attr_accessible :portada_id, :position, :type
    has_many :posts, :through => :section_posts
  end
end
