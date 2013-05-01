unless AdminUser.find_by_email('admin@example.com').present?
  AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
end

john  = User.create!(:email => 'john@example.com', :password => 'password', :password_confirmation => 'password')
mary = User.create!(:email => 'mary@example.com', :password => 'password', :password_confirmation => 'password')

billing = Department.create!(:name => 'Billing', :ref_code => 'BIL')
hosting = Department.create!(:name => 'Hosting', :ref_code => 'HOS')
dns     = Department.create!(:name => 'DNS', :ref_code => 'DNS')
email   = Department.create!(:name => 'Email', :ref_code => 'EML')

Issue.create!(:name => 'Cathy', :email => 'cathy@example.com', :department_id => billing.id, :subject => 'Incorrect Payment', :body => 'Cras vel leo eget urna imperdiet rhoncus.' )
Issue.create!(:name => 'David', :email => 'david@example.com', :department_id => hosting.id, :subject => 'No sudo access', :body => 'Cras vel leo eget urna imperdiet rhoncus.' ).cancel!
Issue.create!(:name => 'Edwin', :email => 'edwin@example.com', :department_id => dns.id, :subject => 'CNAME records', :body => 'Cras vel leo eget urna imperdiet rhoncus.' ).resolve!
Issue.create!(:name => 'Felix', :email => 'felix@example.com', :department_id => hosting.id, :subject => 'Extra disk space', :body => 'Cras vel leo eget urna imperdiet rhoncus.' ).suspend!
