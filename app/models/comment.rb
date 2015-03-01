class Comment < ActiveRecord::Base
  validates_presence_of :user_name, :user_email, :content
  validates_format_of :user_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :as_parent, :class_name => 'Subcomment', :foreign_key => 'comment_id'
  has_many :children, through: :as_parent, :source => 'child'

  has_one :as_children, :class_name => 'Subcomment', :foreign_key => 'child_id'
  has_one :parent, :through => :as_children, :source => 'comment'

  belongs_to :article

  def deeps
    child = Subcomment.where(child_id: self.id).first
    if child
      deeps = child.deeps
    else
      deeps = 0
    end
  end
end