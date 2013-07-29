module Crowdblog
  class Banner < ActiveRecord::Base
    attr_accessible :end_date, :html_code, :image, :space, :start_date, :url
    mount_uploader :image, BannerUploader

    scope :todays, lambda { where("start_date <= ? AND end_date >= ?", Time.now, Time.now) }

    def self.for_cover
      pass_hash = {}
      todays.each do |banner|
        pass_hash.merge!({"#{banner.space}" => banner })
      end
      pass_hash
    end
  end
end
