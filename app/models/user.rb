class User
  include DataMapper::Resource
  include DataMapper::Timestamps
  include HasConstant
  # include HasConstant::Orm::Mongoid
  include Gravtastic
  is_gravtastic

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  property :id, Serial
  property :username, String
  property :api_key, String
  property :role, Integer
  property :type, String

  attr_accessor :company_name

  has n,  :leads
  has n,  :comments
  has n,  :emails
  has n,  :tasks
  has n,  :accounts
  has n,  :contacts
  has n,  :activities
  has n,  :searches
  has n,  :invitations, :as => :inviter, :dependent => :destroy
  has 1,   :invitation,  :as => :invited
  has n,  :opportunities
  has n,  :assigned_opportunities, :foreign_key => 'assignee_id',
    :model => 'Opportunity'

  belongs_to :company, :required => true

  before :valid? do
    set_api_key if new_record?
  end
  before :valid? do
    create_company if new_record?
  end
  before :create, :set_default_role
  after :create, :update_invitation

  has_constant :roles, ROLES

  def invitation_code=( invitation_code )
    if @invitation = Invitation.first(:conditions => { :code => invitation_code })
      self.company_id = @invitation.inviter.company_id
      self.username = @invitation.email.split('@').first if self.username.blank?
      self.email = @invitation.email if self.email.blank?
      self.role = @invitation.role
    end
  end

  def deleted_items_count
    [Lead, Contact, Account, Comment].map do |model|
      model.permitted_for(self).deleted.count
    end.inject {|sum, n| sum += n }
  end

  def full_name
    username.present? ? username : email.split('@').first
  end
  alias :name :full_name

  def recent_items
    Activity.where(:user_id => self.id,
                   :action => I18n.locale_around(:en) { Activity.actions.index('Viewed') }).
                   desc(:updated_at).limit(5).map(&:subject)
  end

  def tracked_items
    (Lead.tracked_by(self) + Contact.tracked_by(self) + Account.tracked_by(self)).
      sort_by(&:created_at)
  end

  def self.send_tracked_items_mail
    User.all.each do |user|
      UserMailer.tracked_items_update(user).deliver if user.new_activity?
      user.tracked_items.each do |item|
        item.related_activities.not_notified(user).each do |activity|
          activity.update_attributes :notified_user_ids => (activity.notified_user_ids || []) << user.id
        end
      end
    end
  end

  def new_activity?
    (self.tracked_items.map {|i| i.related_activities.not_notified(self).count }.
      inject {|sum,n| sum += n } || 0) > 0
  end

  def dropbox_email
    "#{api_key}@salesflip.appspotmail.com"
  end

protected
  def set_api_key
    UUID.state_file = false # for heroku
    self.api_key = UUID.new.generate
  end

  def create_company
    company = Company.new :name => self.company_name
    self.company = company if company.save
  end

  def update_invitation
    @invitation.update_attributes :invited_id => self.id unless @invitation.nil?
  end

  def set_default_role
    self.role = 'Sales Person' if self.role.blank?
  end
end
