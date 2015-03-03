class AddDeepsToComment < ActiveRecord::Migration
  def change
    add_column :comments, :deeps, :integer, :default => 0
  end
end
