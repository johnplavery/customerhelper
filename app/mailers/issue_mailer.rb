class IssueMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_issue(issue)
    @issue = issue
    mail(:to => issue.email, :subject => "[#{issue.ref}] New Issue Opened: #{issue.subject}")
  end

  def updated_issue(issue, reply)
    @issue = issue
    @reply = reply
    mail(:to => issue.email, :subject => "[#{issue.ref}] Issue Updated by #{reply.user.email}")
  end

end
