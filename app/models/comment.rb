class Comment < ActiveRecord::Base
  validates_presence_of :user_name, :content

  belongs_to :article
end