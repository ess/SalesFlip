namespace :db do
  namespace :test do
    task :prepare do
    end
  end

  desc 'Import leads csv'
  task :import_leads_csv => :environment do
    user = User.first(:email => /beedle/i)
    data = {}
    File.open('leads.csv', 'r').each_with_index do |line, index|
      next if index == 0
      details = line.split(',')
      company, contact_names, phone, email, url = details[0], details[1], details[2], details[3], details[4]
      if data[company].blank?
        data[company] = { :contact_names => [contact_names], :phones => [phone], :emails => [email],
          :urls => [url] }
      else
        data[company][:contact_names] << contact_names
        data[company][:phones] << phone
        data[company][:emails] << email
        data[company][:urls] << url
      end
    end

    data.each do |key, attributes|

      contact_names = attributes.delete(:contact_names)
      contact_names.each_with_index do |name, index|
        names = name.strip.gsub(/\"/, '').split(/\s/)
        I18n.in_locale(:de) do
          lead = user.leads.build :company => key, :salutation => names.first,
            :first_name => names[1], :last_name => names.last || 'Unknown',
            :do_not_log => true, :do_not_notify => true, :do_not_index => true,
            :phone => attributes[:phones].shift, :email => attributes[:emails].shift,
            :notes => attributes[:urls].delete_if { |url|
              url.match(/@/)
            }.map { |url| "<a href='#{url}' target='_blank'>#{url}</a>" }.join('<br/>'),
            :source => 'Other'
          next if Lead.first(:email => /#{lead.email}/i)

          ids = Account.only(:id, :name).map do |account|
            [account.id, lead.company.levenshtein_similar(account.name)]
          end.select { |similarity| similarity.last > 0.9 }.map(&:first)

          unless ids.blank?
            puts "Skipped lead #{lead.name} (#{lead.company})"
            puts "Similar accounts: #{Account.all(:_id => ids).map(&:name).join(', ')}"
            next
          end

          if lead.similar(0.85).any?
            puts "Skipped lead #{lead.name}, (#{lead.company})"
            puts "Similar leads: #{Lead.all(:_id => ids).map(&:company).join(', ')}"
            next
          end
          if lead.save
            puts "Created lead #{lead.name} (#{lead.company})"
            Sunspot.index lead
          else
            puts names.inspect
            puts names.first
            throw lead
          end
        end
      end
    end
  end

  desc "Convert MongoDB data to Postgres"
  task :migrate_data => :environment do
    Dir[ File.join(Rails.root, "db", "migrate", "*.rb") ].sort.each { |file| require file }

    puts "Migrating the MongoDB data to PostgreSQL"
    [ MigrateAccounts, MigrateActivities, MigrateAttachments, MigrateComments,
      MigrateCompanies, MigrateContacts, MigrateDomains, MigrateLeads, MigrateTasks ].each do |migration|
      migration.up
    end
  end

  desc "Convert MongoDB users to Postgres"
  task :migrate_users => :environment do
    Dir[ File.join(Rails.root, "db", "migrate", "*.rb") ].sort.each { |file| require file }

    puts "Migrating the users"
    MigrateUsers.up
  end

  desc "Re-relate the Postgre relations"
  task :re_relate => :environment do
    Dir[ File.join(Rails.root, "db", "migrate", "*.rb") ].sort.each { |file| require file }

    puts "Hooking up the Postgre Relations"
    [ AssociateAccounts, AssociateActivities, AssociateAttachments, AssociateComments,
      AssociateContacts, AssociateLeads, AssociateTasks, AssociateUsers ].each do |migration|
      migration.up
    end
  end

  desc "Fix has constants"
  task :fix_has_constants => :environment do
    Dir[ File.join(Rails.root, "db", "migrate", "*.rb") ].sort.each { |file| require file }

    puts "Fixing has constants"
    FixHasConstants.up
  end

  desc "Fix Attachments"
  task :fix_attachments => :environment do
    Dir[ File.join(Rails.root, "db", "migrate", "*.rb") ].sort.each { |file| require file }

    puts 'Fixing attachments'
    FixAttachments.up
  end

  desc 'Migrate opportunity stages to has_constant'
  task :migrate_opportunity_stages => :environment do
    Opportunity.all.each do |o|
      o.stage = 'New'
      o.save!
    end
  end
end
