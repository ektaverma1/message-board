class Post < ApplicationRecord
	  paginates_per 2
  	belongs_to :user
  	has_many :comments, dependent: :destroy
  	acts_as_votable

    validates :title, presence: true
    validates :body, presence: true
    validates :website_url, :format => URI::regexp(%w(http https))

    scope :search_posts, ->(params) {joins("left join comments on comments.post_id = posts.id").where("posts.user_id = ? or comments.user_id= ? ",params[:user_id],params[:user_id]) }

    scope :contains_blog_keyword, ->(params) { where("title ILIKE ? or body ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")}

  	def is_it_published?
      unless self.published_at.nil?
    	  self.published_at + 1.hour > (DateTime.now) 
      else
        true
  	end
  end

end
