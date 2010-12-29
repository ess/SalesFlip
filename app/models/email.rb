class Email < Comment
  property :received_at, Time
  property :from, String

  validates_presence_of :received_at, :subject, :from

  alias :name :subject
end
