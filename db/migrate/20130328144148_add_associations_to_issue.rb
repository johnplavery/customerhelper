class AddAssociationsToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :user_id, :integer
    add_column :issues, :department_id, :integer
  end
end
