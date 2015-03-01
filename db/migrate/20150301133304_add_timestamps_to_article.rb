class AddTimestampsToArticle < ActiveRecord::Migration
  def change
    change_table :articles do |t|
        t.timestamps
    end
  end
end
