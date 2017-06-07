class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :get_post, only: [:create, :edit, :update, :destroy, :upvote, :downvote]
	before_action :fetch_comment, only: [:edit, :update, :destroy, :upvote, :downvote]

	def create
		@comment = @post.comments.create(comment_params)
		@comment.user= current_user
		if @comment.save
			redirect_to post_path(@post)
		else
			render 'new'
		end
	end

	def destroy
		@comment.destroy
		redirect_to post_path(@post)
	end

	def upvote
		@comment.upvote_from current_user
		redirect_to post_path(@post)
	end

	def downvote
		@comment.downvote_from current_user
		redirect_to post_path(@post)
	end

	private

	def comment_params
		params.require(:comment).permit(:content)
	end

	def get_post
		@post = Post.find(params[:post_id])
	end

	def fetch_comment
		@comment = @post.comments.find(params[:id])
	end
end
