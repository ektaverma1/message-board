class Comment < ApplicationRecord
	belongs_to :post
  	belongs_to :user
  	acts_as_votable
  	scope :search_commenter,-> (params) { where("user_id = ?", params[:user_id])}
end
