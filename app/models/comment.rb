class Comment
  include DataMapper::Resource
  include DataMapper::Timestamps
  include HasConstant::Orm::DataMapper
  include Activities
  include Permission
  include ParanoidDelete

  property :id, Serial
  property :subject, String
  property :text, String, :required => true
  property :type, Discriminator
  property :created_at, DateTime
  property :created_on, Date
  property :updated_at, DateTime
  property :updated_on, Date

  belongs_to :user, :required => true

  belongs_to :commentable, polymorphic: true, required: true, suffix: 'type'

  has n, :attachments, :as => :subject, :suffix => :type

  after :create, :add_attachments

  def self.sorted
    all(:order => :created_at.asc)
  end

  def name
    "#{text[0..30]}..."
  end

  def attachments_attributes=( attribs )
    @attachments_to_add = []
    attribs.each do |hash|
      @attachments_to_add << hash
    end if attribs
  end

protected
  def add_attachments
    @attachments_to_add.each do |a|
      self.attachments.create(a)
    end if @attachments_to_add
  end
end
