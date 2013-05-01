class Issue < ActiveRecord::Base
  attr_accessible :body, :department_id, :email, :name, :subject

  belongs_to :department
  belongs_to :user

  has_many :replies

  validates :ref, :name, :email, :subject, :body, :department, :state, presence: true
  validates :ref, :uniqueness => true

  validates_email_format_of :email

  before_validation :set_reference_number

  state_machine :state, :initial => :waiting_for_staff_response do

    event :updated_by_staff do
      transition any - [:cancelled, :completed] => :waiting_for_customer
    end

    event :updated_by_customer do
      transition any - [:cancelled, :completed] => :waiting_for_staff_response
    end

    event :suspend do
      transition [:waiting_for_staff_response, :waiting_for_customer] => :on_hold
    end

    event :cancel do
      transition any - [:cancelled, :completed] => :cancelled
    end

    event :resolve do
      transition any - [:cancelled, :completed] => :completed
    end

    state :waiting_for_staff_response, :waiting_for_customer, :on_hold do
      def closed?
        false
      end
    end

    state :cancelled, :completed do
      def closed?
        true
      end
    end

  end

  scope :unassigned, where(:user_id => nil).with_states(:waiting_for_staff_response)
  scope :open, with_states(:waiting_for_staff_response, :waiting_for_customer)
  scope :on_hold, with_states(:on_hold)
  scope :closed, with_states(:cancelled, :completed)

  def self.states
    self.state_machines[:state].states.map &:name
  end

  def add_reply( message, replying_user = nil, event = :update, assigned_user = nil )
    reply = replies.new( body: message, user: replying_user )
    starting_state = state

    # Update the issue's assigned user if required
    if assigned_user.present? and assigned_user != self.user
      reply.assigned_user = assigned_user
      self.user = assigned_user
    end

    # Carry out any events
    case event
    when :suspend
      suspend!
    when :cancel
      cancel!
    when :resolve
      resolve!
    else
      if replying_user.nil?
        updated_by_customer!
      elsif !message.empty?
        updated_by_staff!
      end
    end

    if starting_state != state
      reply.state_change = human_state_name
    end

    reply.save!

    return reply
  end

  def user_id
    user.id unless user.nil?
  end

  def to_param
    ref
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['ref LIKE ? OR body LIKE ?',"%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

private

  def set_reference_number
    if ref.nil? and department.present?
      self.ref = loop do
        ref_code = generate_ref
        break ref_code unless self.class.where(ref: ref_code).exists?
      end
    end
  end

  def generate_ref
    "#{department.ref_code}-#{sprintf( '%06d', SecureRandom.random_number(999999) )}"
  end

end
