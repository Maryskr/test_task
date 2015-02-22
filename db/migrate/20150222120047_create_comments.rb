class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_avatar, :default => 'noavatar.png'
      t.string :user_name
      t.text :content
      t.integer :rating, :default => 0
      t.belongs_to :articles
      t.timestamp
    end
  end
end
