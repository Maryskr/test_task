class DropSubcomment < ActiveRecord::Migration
  def change
    drop_table :subcomments
  end
end
