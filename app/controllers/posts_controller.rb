class PostsController < ApplicationController
	before_action :authenticate_user!
	before_action :get_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote,:publish]
	before_action :remove_params, only: :index

	def index
		@users = User.all
		@posts = (params[:user_id].nil? && params[:search].nil?) ? Post.all : Post.search_posts(params) 
		@posts = @posts.order("created_at DESC").page(params[:page])
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			redirect_to posts_path
		else
			render 'new'
		end
	end

	def show
	end

	def publish
		@post.published_at = DateTime.now
		@post.save
		redirect_to posts_path
	end

	def edit
		if !@post.is_it_published?
			redirect_to @post, flash: { alert: "Post has been Published since 1 hour and not editable anymore" }
		end
	end

	def update
		@post = Post.find(params[:id])

		if @post.update(params[:post].permit(:title, :body, :website_url))
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post.destroy
		redirect_to posts_path
	end

	def upvote
		@post.upvote_from current_user
		redirect_to posts_path
	end

	def downvote
		@post.downvote_from current_user
		redirect_to posts_path
	end

	private

	def get_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:title, :body, :website_url)
	end

	def remove_params
		Rails.logger.info "========remove_params====#{params.inspect}"
		params.reject!{|_, v| v.blank?}
	end
end
