module Crowdblog
  class Esnoticia < ActiveRecord::Base
    belongs_to :tag, :class_name => "ActsAsTaggableOn::Tag", :foreign_key => "tag_id"

    attr_accessible :tag_id
  end
end
