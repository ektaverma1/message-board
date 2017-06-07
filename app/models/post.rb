class Post < ApplicationRecord
	  paginates_per 3
  	belongs_to :user
  	has_many :comments, dependent: :destroy
  	acts_as_votable

    validates :title, presence: true

  	scope :search_posts, ->(params) {joins(:comments).where("title like ? or body like ? or posts.user_id=? or comments.user_id=? ",params[:search],params[:search],params[:user_id],params[:user_id]) }
  
  	def is_it_published?
      unless self.published_at.nil?
    	  self.published_at + 1.hour > (DateTime.now) 
      else
        true
  	end
  end

end
