module Crowdblog
  class WeatherNote < ActiveRecord::Base
    attr_accessible :balazo, :portada_id, :title, :post_id

    belongs_to :post, :class_name => "Post", :foreign_key => "post_id"
    accepts_nested_attributes_for :post, allow_destroy: true

  end
end
