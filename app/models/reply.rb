class Reply < ActiveRecord::Base
  has_one:user

  validates :reply, :presence => true

end
