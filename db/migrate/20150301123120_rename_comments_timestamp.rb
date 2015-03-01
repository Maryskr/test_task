class RenameCommentsTimestamp < ActiveRecord::Migration
  def change
    change_table :comments do |t|
        t.timestamps
    end
  end
end
