class ChangeColumnNameToComments < ActiveRecord::Migration
  def change
    rename_column :comments, :articles_id, :article_id
  end
end
