class Comment < ActiveRecord::Base
  validates_presence_of :user_name, :content

  has_many :as_parent, :class_name => 'Subcomment', :foreign_key => 'comment_id'
  has_many :children, through: :as_parent, :source => 'child'

  has_one :as_children, :class_name => 'Subcomment', :foreign_key => 'child_id'
  has_one :parent, :through => :as_children, :source => 'comment'

  belongs_to :article
end