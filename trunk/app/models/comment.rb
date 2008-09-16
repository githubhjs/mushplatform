class Comment < ActiveRecord::Base
  blongs_to :blog
end
