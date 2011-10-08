class User < ActiveRecord::Base
  has_many:posts
  has_many:replies


  validates :unityId, :presence => true, :uniqueness => true
  validates :userName, :presence => true, :length => {:minimum => 6, :maximum => 30}
  validates :password, :presence => true, :length => {:minimum => 6, :maximum => 30}
  validates :emailAddress, :presence => true, :length => {:minimum => 6, :maximum => 20}
  validates :role,:presence => true
  validates_presence_of :userName
  validates_uniqueness_of :userName
  validates_confirmation_of :password

end
