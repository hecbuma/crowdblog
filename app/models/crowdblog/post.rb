module  Crowdblog
  class Post < ActiveRecord::Base
    belongs_to :author, :class_name => Crowdblog.author_user_class_name
    belongs_to :publisher, :class_name => Crowdblog.publisher_user_class_name
    has_many :assets

    delegate :name, to: :author, prefix: true, allow_nil: true
    delegate :email, to: :author, prefix: true, allow_nil: true
    delegate :gravatar_url, to: :author

    delegate :year, to: :published_at

    attr_accessor :transition
    attr_accessible :title, :body, :updated_by, :ready_for_review, :transition, :related_attributes, :picture_only,
                    :vlog, :opinion, :short_url

    #TODO: move to decorator
    attr_accessible :cintillo, :resumen, :category_id, :tag_list, :image, :remote_image_url
    acts_as_taggable
    belongs_to :category
    mount_uploader :image, ImageUploader
    has_many :section_posts
    has_many :home_sections, :through => :section_posts

    has_many :related, :class_name => "Post", :foreign_key => "related_id"
    accepts_nested_attributes_for :related, allow_destroy: true

    after_save :reindex

    LEGACY_TITLE_REGEXP = /(\d+-\d+-\d+)-(.*)/

    state_machine initial: :drafted do
      state :drafted
      state :finished
      state :reviewed
      state :published

      event :finish do
        transition drafted: :finished
      end

      event :draft do
        transition finished: :drafted
      end
    end

    state_machine :publisher, attribute: :state, initial: :drafted, namespace: :as_publisher do
      state :drafted
      state :finished
      state :reviewed
      state :published

      before_transition on: :publish do |post, transition|
        post.published_at ||= Time.now
        post.generate_short_url
      end

      before_transition on: :draft do |post, transition|
        post.published_at = nil
      end

      event :draft do
        transition published: :drafted
      end

      event :finish do
        transition drafted: :finished
      end

      event :review do
        transition finished: :reviewed
      end

      event :publish do
        transition all => :published
      end
    end

    searchable do
      text :title, :body
      string :state
      time :published_at
      boolean :picture_only
      boolean :vlog
      boolean :opinion
      string :category_name do
        category.name if category
      end
      string :author_id
    end

    # CLASS METHODS
    class << self
      def all_posts_json
        includes(:author).
            order_by_publish_date.to_json only: [:id, :title, :state, :published_at, :ready_for_review],
                                      methods: [:author_email, :published?]
      end

      def by_author(author_id)
        published_and_ordered.where(author_id: author_id)
      end

      def last_published(number)
        published_and_ordered.limit(number)
      end

      def order_by_publish_date
        order('published_at DESC, created_at DESC, id DESC')
      end

      def published
        where(state: 'published')
      end

      def published_and_ordered
        published.order_by_publish_date.includes(:author)
      end

      def scoped_for(user)
        user.is_publisher? ? scoped : user.authored_posts
      end

      def for_admin_index
        includes(:author).ordered_by_state.order_by_publish_date
      end

      def ordered_by_state
        order(:state)
      end

      #TODO: remove this super ugly method and implement STI
      def by_type(type)
        if type == 'vlog'
          vlog = true
          vlog_op = '='
        else
          vlog = nil
          vlog_op = 'IS'
        end
        if type == 'opinion'
          opinion = true
          opinion_op = '='
        else
          opinion = nil
          opinion_op = 'IS'
        end

        where("vlog #{vlog_op} ? AND opinion #{opinion_op} ?", vlog, opinion)
      end
    end

    # Must be after Class methods (otherwise a missing method error will raise)
    scope :for_index,     last_published(20)
    scope :for_history,   last_published(13)
    scope :all_for_feed,  last_published(15)
    scope :by_join_date,  published.order("published_at DESC")


    def reindex
      self.index!
    end

    # INSTANCE METHODS
    def allowed_to_update_permalink?
      !self.published?
    end

    def day
      "%02d" % published_at.day
    end

    def formatted_published_date
      published_at.strftime("%b %d, %Y")
    end

    def hour
      published_at.in_time_zone.strftime('%I:%M %p')
    end

    def date_and_hour
      I18n.l published_at.in_time_zone, format: :special
    end

    def html_body
      @@renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                             :autolink => true, :space_after_headers => true)
      @@renderer.render(self.body).html_safe
    end

    def legacy(string, email)
      results = string.match(LEGACY_TITLE_REGEXP)
      self.published_at = "#{results[1]}"
      user = User.find_by_email(email) || User.create!(email: email)
      self.author = user
      self.save
      self.publish
      self.update_attribute(:permalink, results[2])
    end

    def month
      "%02d" % published_at.month
    end

    def publish_if_allowed(transition, user)
      if user.is_publisher?
        self.publisher = user
        self.send(transition)
      end
    end

    def generate_short_url
      unless published_at.nil? || id.nil? || short_url || permalink.nil?
        url = Rails.application.routes.url_helpers.post_url(*self.url_params)
        if Rails.env.production?
          short = Shortener.shorten(url)
          self.short_url = short.short_url
        else
          self.short_url = Rails.application.routes.url_helpers.post_url(*self.url_params)
        end
      end
    end

    def regenerate_permalink
      self.permalink = title.parameterize
    end

    #
    # Use this methods to generate the post url
    # always use with the splat
    # operator
    #
    # Example:
    #   post_url(*post.url_params)
    #
    def url_params
      [self.year, self.month, self.day, self.permalink, 'html']
    end

  end
end
