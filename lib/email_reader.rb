class EmailReader

  def self.check_mail( configuration )
    imap = Net::IMAP.new(configuration.imap_host, 993, true)
    imap.login(configuration.imap_user, configuration.imap_password)
    imap.select('INBOX')
    imap.search(['NOT', 'DELETED', 'NOT', 'SEEN']).each do |message_id|
      email = Mail.new(imap.fetch(message_id, 'RFC822')[0].attr['RFC822'])
      imap.store(message_id, '+FLAGS', [:Deleted]) if parse_email(email)
    end
    imap.expunge
    imap.logout
    imap.disconnect
  end

  def self.parse_email( email )
    if user = find_user_from(email)
      unless target = find_target(email)
        target = create_contact_from(email)
      end
      comment = Email.create :text => get_email_content(email),
        :commentable => target, :user => user, :subject => get_subject(email),
        :received_at => Time.zone.now, :from => incoming?(email) ? find_target_email(email) : user.email
      add_attachments( comment, email ) if comment
      return comment
    end
    user
  end

protected
  def self.get_subject( email )
    if subject = Mail.new(get_email_content(email)).subject
      subject
    else
      email.subject.encode('utf-8')
    end
  end

  # emails sent directly to salesflip are forwarded
  def self.incoming?( email )
    email.to.to_a.first.match(/salesflip/)
  end

  def self.get_email_content( email )
    if email.content_type.match(/text\/plain/)
      return email.body.to_s.force_encoding(email.charset).encode('utf-8')
    else
      email.parts.each do |part|
        return get_email_content(part)
      end
    end
  end

  def self.add_attachments( comment, email )
    email.attachments.each do |attachment|
      file = File.open("tmp/#{attachment.filename}", 'w+') do |f|
        f.write attachment.read.force_encoding('utf-8')
      end
      comment.attachments << Attachment.new(:attachment => File.open("tmp/#{attachment.filename}"))
    end
  end

  def self.find_target( email )
    target = Lead.first(:conditions => { :email => /#{find_target_email(email)}/i, :status => 'New' })
    target = Contact.first(:conditions => { :email => /#{find_target_email(email)}/i }) unless target
    target = Account.first(:conditions => { :email => /#{find_target_email(email)}/i }) unless target
    target = Lead.first(:conditions => { :email => /#{find_target_email(email)}/i }) unless target
    target
  end

  def self.find_target_email( email )
    mail = Mail.new(get_email_content(email))
    user = find_user_from(email)
    if not mail.from.blank? and mail.from.first != user.email
      mail.from.first
    elsif not mail.to.blank? and mail.to.first != user.email
      mail.to.first
    else
      email.to.first
    end
  end

  def self.create_contact_from( email )
    target_email = find_target_email(email)
    account = Account.create(:name => target_email.split('@').last, :user => find_user_from(email))
    Contact.create(:email => target_email,
                   :first_name => target_email.split('@').first.split('.').first,
                   :last_name => target_email.split('@').first.split('.').last,
                   :account => account, :user => find_user_from(email))
  end

  def self.find_user_from( email )
    api_key = email.to.to_a.first.split('@').first
    user = User.first(:conditions => { :api_key => api_key })
    user = User.first(:conditions => { :email => email.from.to_a.first.strip }) if user.nil?
    user
  end
end
