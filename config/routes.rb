Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :posts do
    	resources :comments do
        member do
          put "like" => "comments#upvote"
          put "unlike" => "comments#downvote"
        end
      end

    	member do
  		  put "like" => "posts#upvote"
  		  put "unlike" => "posts#downvote"
        post "publish" => "posts#publish"
  	  end
  end
end
