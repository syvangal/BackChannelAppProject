class Post < ActiveRecord::Base
  belongs_to :user

validates :user, :presence => :true

  validates :postString, :presence => true

end
