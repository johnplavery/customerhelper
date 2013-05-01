require 'spec_helper'

describe Issue do

  describe "validation" do

    before :all do
      @department = Department.create!( name: 'Test Dept.', ref_code: 'TST' )
      @expected_params = { name: "John Doe", email: "john.doe@example.com", subject: "Testing", department_id: @department.id, body: 'Lorum ipsum dolor sit amet' }
    end

    before :each do
      @issue = Issue.new( @expected_params )
    end

    it "should be valid with expected parameters" do
      @issue.should be_valid
    end

    it "should require name" do
      @issue.name = nil
      @issue.should_not be_valid
    end

    it "should require email" do
      @issue.email = nil
      @issue.should_not be_valid
    end

    it "should require subject" do
      @issue.subject = nil
      @issue.should_not be_valid
    end

    it "should require email to be a valid address" do
      @issue.email = 'john.doe.com'
      @issue.should_not be_valid
    end

    it "should require department" do
      @issue.department = nil
      @issue.should_not be_valid
    end

    it "should require body" do
      @issue.body = nil
      @issue.should_not be_valid
    end

    it "should require a reference number" do
      @issue.ref = nil
      @issue.department = nil
      @issue.should_not be_valid
    end

    it "should require a unique reference number" do
      @issue.should be_valid
      @issue.save!
      new_issue = Issue.new @expected_params
      new_issue.ref = @issue.ref
      new_issue.should_not be_valid
    end

  end

  describe "states" do

    it "should list all state names correctly" do
      Issue.states.sort.should == [:waiting_for_staff_response, :waiting_for_customer, :on_hold, :cancelled, :completed].sort
    end

    before :each do
      @department = Department.create!( name: 'Test Dept', ref_code: 'TST' )
      @issue = Issue.create!( name: "John Doe", email: "john.doe@example.com", subject: "Testing", department_id: @department.id, body: 'Lorum ipsum dolor sit amet' )
      @user = User.create!( email: "staff@example.com", password: "password123", password_confirmation: "password123" )
    end

    describe ':waiting_for_staff_response' do

      it 'should be the initial state' do
        @issue.waiting_for_staff_response?.should be_true
      end

      it 'should not be considered closed' do
        @issue.closed?.should be_false
      end

      it 'should transition to :waiting_for_customer when replied to by staff' do
        @issue.add_reply( 'Lorum ipsum dolor sit amet', @user )
        @issue.waiting_for_customer?.should be_true
      end

    end

    describe ':waiting_for_customer' do

      before :each do
        @issue.add_reply( 'Lorum ipsum dolor sit amet' )
      end

      it 'should not be considered closed' do
        @issue.closed?.should be_false
      end

      it "should transition to :waiting_for_staff_response when replied to by customer" do
        @issue.waiting_for_staff_response?.should be_true
      end

    end

    describe ':on_hold' do

      before :each do
        @issue.suspend!
      end

      it "should transition to :on_hold after suspend event" do
        @issue.on_hold?.should be_true
      end

      it 'should not be considered closed' do
        @issue.closed?.should be_false
      end

      it "should transition to :waiting_for_staff_response when replied to by customer" do
        @issue.add_reply( 'Lorum ipsum dolor sit amet' )
        @issue.waiting_for_staff_response?.should be_true
      end

      it 'should transition to :waiting_for_customer when replied to by staff' do
        @issue.add_reply( 'Lorum ipsum dolor sit amet', @user )
        @issue.waiting_for_customer?.should be_true
      end

    end

    describe ':cancelled' do

      before :each do
        @issue.cancel!
      end

      it 'should transition to :cancelled after cancel event' do
        @issue.cancelled?.should be_true
      end

      it 'should be considered closed' do
        @issue.closed?.should be_true
      end

    end

    describe ':completed' do

      before :each do
        @issue.resolve!
      end

      it 'should transition to :completed after resolve event' do
        @issue.completed?.should be_true
      end

      it 'should be considered closed' do
        @issue.closed?.should be_true
      end
    end

  end

end
