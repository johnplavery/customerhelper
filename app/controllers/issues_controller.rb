class IssuesController < ApplicationController
  before_filter :verify_user_auth, except: [:show, :new, :create, :update]

  def show
    @issue = Issue.find_by_ref(params[:id])
    @users = User.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  def new
    @issue = Issue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  def create
    @issue = Issue.new(params[:issue])

    respond_to do |format|
      if @issue.save
        IssueMailer.new_issue(@issue).deliver

        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    event = params[:commit].parameterize.downcase.to_sym
    assigned_user = User.find_by_id(params[:assigned_user_id])

    @issue = Issue.find_by_ref(params[:id])
    @reply = @issue.add_reply( params[:message], current_user, event, assigned_user )

    # Send user any updates made by staff
    if current_user
      IssueMailer.updated_issue(@issue, @reply).deliver
    end

    respond_to do |format|
      format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
      format.json { head :no_content }
    end

  end

  def index
    @issues = Issue.send params[:scope].to_sym

    respond_to do |format|
      format.html # unassigned.html.erb
      format.json { render json: @issues }
    end
  end

  def search
    @term = params[:s] || ""
    @issues = Issue.search @term
  end

private

  def verify_user_auth
    redirect_to root_path, :flash => { :error => "Unauthorized!" } unless user_signed_in?
  end

end
