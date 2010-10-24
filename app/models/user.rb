class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  is_gravtastic

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  field :username
  field :api_key

  attr_accessor :company_name

  has_many_related  :leads, :index => true
  has_many_related  :comments, :index => true
  has_many_related  :emails, :index => true
  has_many_related  :tasks, :index => true
  has_many_related  :accounts, :index => true
  has_many_related  :contacts, :index => true
  has_many_related  :activities, :index => true
  has_many_related  :searches, :index => true
  has_many_related  :invitations, :as => :inviter, :dependent => :destroy, :index => true
  has_one_related   :invitation, :as => :invited, :index => true

  belongs_to_related :company

  before_validation :set_api_key, :create_company, :on => :create
  after_create :update_invitation#, :add_user_to_postfix

  validates_presence_of :company

  def invitation_code=( invitation_code )
    if @invitation = Invitation.first(:conditions => { :code => invitation_code })
      self.company_id = @invitation.inviter.company_id
      self.username = @invitation.email.split('@').first if self.username.blank?
      self.email = @invitation.email if self.email.blank?
    end
  end

  def deleted_items_count
    [Lead, Contact, Account, Comment].map do |model|
      model.permitted_for(self).deleted.count
    end.inject {|sum, n| sum += n }
  end

  def full_name
    username.present? ? username : email
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

  def add_user_to_postfix
    Alias.create :mail => "@#{self.api_key}.salesflip.com",
      :destination => 'catch.all@salesflip.com'
    Domain.create :domain => "#{self.api_key}.salesflip.com"
  end
end
