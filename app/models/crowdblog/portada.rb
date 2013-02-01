module Crowdblog
  class Portada < ActiveRecord::Base
    attr_accessible :breaking_news, :plubication
    has_many :home_sections
  end
end
