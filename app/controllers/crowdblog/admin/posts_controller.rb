module Crowdblog
  module Admin
    class PostsController < Crowdblog::Admin::BaseController
      respond_to :html, :json
      cache_sweeper :post_sweeper

      before_filter :load_post, :only => [ :edit, :update, :destroy ]

      def new
        attributes = {}
        attributes = attributes.merge params[:type] == 'vlog' ? {vlog: 'true'} : {}
        attributes = attributes.merge params[:type] == 'opinion' ? {opinion: 'true'} : {}
        @post = Post.new attributes
        @post.author = current_user
        @post.save!
        redirect_to edit_admin_post_path(@post)

      end

      def index
        @state = params[:state]
        # @posts = Post.scoped_for(current_user).for_admin_index.paginate(:page => params[:page], :per_page => 50).by_type(params[:type])
        # @posts = @posts.with_state(@state) if @state && @state != 'any'
        author = current_user.is_publisher? ? nil : current_user.id
        state = params[:state] && params[:state] != 'any' ? params[:state] : nil
        vlog = params[:type] == 'vlog' ? 'vlog' : nil
        opinion = params[:type] == 'opinion' ? 'opinion' : nil
        # @posts = ::Post.query('',false).results
        @posts = ::Post.query_for_admin('',author, 50, params[:page], state, false, vlog, opinion).results

        respond_with @posts
      end

      def create
        @post = Crowdblog::Post.new(post_params)
        @post.author = current_user
        @post.regenerate_permalink
        if @post.save
          respond_with @post, :location => crowdblog.admin_posts_path
        end
      end

      def destroy
        @post.destroy
        respond_with @post, :location => crowdblog.admin_posts_path
      end

      def show
        @post = Crowdblog::Post.includes(:assets).find(params[:id])
        respond_to do |format|
          format.json { render json: @post.to_json(include: :assets) }
        end
      end

      def edit
        @categories = Category.all
      end

      def update
        @post.update_attributes(post_params, updated_by: current_user)
        if @post.allowed_to_update_permalink?
          @post.regenerate_permalink
          @post.save!
        end

        respond_with @post do |format|
          format.html { redirect_to crowdblog.admin_posts_path }
        end
      end

      private
      def load_post
        @post = Post.scoped_for(current_user).find(params[:id])
      end

      def post_params
        # params.require(:post).permit(:title, :body, :updated_by, :ready_for_review, :transition)
        #TODO move to decorator
        params.require(:post).permit(:title, :body, :cintillo, :resumen, :category_id, :tag_list, :remote_image_url, :updated_by, :ready_for_review, :transition, :related_attributes, :picture_only)
      end
    end
  end
end
