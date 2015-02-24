class Comment < ActiveRecord::Base
  validates_presence_of :user_name, :content
  # has_many :replies, class: "Comment", foreign_key: "reply_id"
  belongs_to :article
end