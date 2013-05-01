class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :ref
      t.string :name
      t.string :email
      t.text :body

      t.timestamps
    end
  end
end
