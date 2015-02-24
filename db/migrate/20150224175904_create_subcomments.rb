class CreateSubcomments < ActiveRecord::Migration
  def change
    create_table :subcomments do |t|
      t.integer :deeps
      t.timestamp
    end
    add_belongs_to :subcomments, :parent
    add_belongs_to :subcomments, :child
  end
end
