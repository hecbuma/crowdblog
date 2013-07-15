module Crowdblog
  class Portada < ActiveRecord::Base
    attr_accessible :breaking_news, :publication, :home_sections_attributes, :section_posts_attributes, :datodeldia,
                    :datopolicia, :soundcloud_frame, :resumen_on_top, :weather_notes_attributes, :special_note_id,
                    :special_note_attributes
    has_many :home_sections, :dependent => :destroy
    accepts_nested_attributes_for :home_sections, allow_destroy: true
    has_many :weather_notes, :dependent => :destroy
    accepts_nested_attributes_for :weather_notes, allow_destroy: true
    belongs_to :special_note, :class_name => "Post", :foreign_key => "special_note_id", :dependent => :destroy
    accepts_nested_attributes_for :special_note, allow_destroy: true

  end
end
