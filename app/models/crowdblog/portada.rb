module Crowdblog
  class Portada < ActiveRecord::Base
    attr_accessor :transition
    attr_accessible :breaking_news, :publication, :home_sections_attributes, :section_posts_attributes, :datodeldia,
                    :datopolicia, :soundcloud_frame, :resumen_on_top, :weather_notes_attributes, :special_note_id,
                    :special_note_attributes, :transition
    has_many :home_sections, :dependent => :destroy
    accepts_nested_attributes_for :home_sections, allow_destroy: true
    has_many :weather_notes, :dependent => :destroy
    accepts_nested_attributes_for :weather_notes, allow_destroy: true
    belongs_to :special_note, :class_name => "Post", :foreign_key => "special_note_id", :dependent => :destroy
    accepts_nested_attributes_for :special_note, allow_destroy: true

    state_machine initial: :drafted do
      state :drafted
      state :published

      event :draft do
        transition all => :drafted
      end

      event :publish do
        transition all => :published
      end
    end

    def clone
      portada = Crowdblog::Portada.new(publication: Date.tomorrow)
      portada.home_sections.new section_type: 'principal'
      portada.home_sections.new section_type: 'secundaria'
      portada.home_sections.new section_type: 'opinion'
      portada.home_sections.new section_type: 'policiacas'
      portada.save

      principal = home_sections.where(section_type: 'principal').first
      secundaria = home_sections.where(section_type: 'secundaria').first
      opinion = home_sections.where(section_type: 'opinion').first
      policiacas = home_sections.where(section_type: 'policiacas').first

      principal.posts.each do |post|
        portada.home_sections.where(section_type: 'principal').first.posts << post
      end
      secundaria.posts.each do |post|
        portada.home_sections.where(section_type: 'secundaria').first.posts << post
      end
      opinion.posts.each do |post|
        portada.home_sections.where(section_type: 'opinion').first.posts << post
      end
      policiacas.posts.each do |post|
        portada.home_sections.where(section_type: 'policiacas').first.posts << post
      end

      portada.save

    end

    def self.todays_cover
      where(state: 'published').order('publication ASC').first
    end

  end
end
