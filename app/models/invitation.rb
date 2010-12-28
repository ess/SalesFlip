class Invitation
  include DataMapper::Resource
  include DataMapper::Timestamps
  include HasConstant
  # include HasConstant::Orm::Mongoid

  property :id, Serial
  property :email, String, :required => true
  property :code, String, :required => true
  property :role, Integer, :required => true

  belongs_to :invited, :model => 'User'
  belongs_to :inviter, :model => 'User', :required => true

  before :valid? do
    generate_code if new_record?
  end
  after :create, :send_invitation

  has_constant :roles, ROLES

  def self.by_company(company)
    all(:inviter_id.in => company.users.map(&:id))
  end

protected
  def generate_code
    UUID.state_file = false
    self.code = UUID.new.generate if code.blank?
  end

  def send_invitation
    InvitationMailer.invitation(self).deliver
  end
end
