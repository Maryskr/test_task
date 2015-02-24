class RenameParentIdToSubcomments < ActiveRecord::Migration
  def change
    rename_column :subcomments, :parent_id, :comment_id
  end
end
