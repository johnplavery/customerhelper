class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :issue_id
      t.integer :user_id
      t.text :body
      t.integer :assigned_user_id
      t.text :state_change

      t.timestamps
    end
  end
end
