class AddSubjectToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :subject, :text
  end
end
