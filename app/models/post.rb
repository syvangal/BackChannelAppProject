class Post < ActiveRecord::Base
  belongs_to :user

validates :postString, :presence => true

end
