# dato del dia
module Crowdblog
  class QuoteNote < ActiveRecord::Base
    attr_accessible :quote, :portada_id, :author, :charge, :post_id

    belongs_to :post, :class_name => "Post", :foreign_key => "post_id"
    accepts_nested_attributes_for :post, allow_destroy: true

  end
end
