class Reply < ActiveRecord::Base
  attr_accessible :assigned_user_id, :body, :issue_id, :state_change, :user_id, :user

  belongs_to :issue
  belongs_to :user
  belongs_to :assigned_user, class_name: 'User'

  def display_user
    user.present? ? user.email : 'Customer'
  end
end
