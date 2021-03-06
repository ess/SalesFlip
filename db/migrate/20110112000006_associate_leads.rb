class AssociateLeads < Migrations::MongodbToPostgresql

  def self.up
    puts "Associating Leads"
    # Migrate the users...
    sql = "UPDATE leads SET user_id = users.id FROM users WHERE users.legacy_id = leads.legacy_user_id"
    postgre.create_command(sql).execute_non_query

    # Migrate the assignees...
    sql = "UPDATE leads SET assignee_id = users.id FROM users WHERE users.legacy_id = leads.legacy_assignee_id"
    postgre.create_command(sql).execute_non_query

    # Migrate the contacts...
    sql = "UPDATE leads SET contact_id = contacts.id FROM contacts WHERE contacts.legacy_id = leads.legacy_assignee_id"
    postgre.create_command(sql).execute_non_query

    # Migrate the updaters...
    sql = "UPDATE leads SET updater_id = users.id FROM users WHERE users.legacy_id = leads.legacy_updater_id"
    postgre.create_command(sql).execute_non_query

    # Migrate the permissions...
    select = "SELECT id, legacy_permitted_user_ids FROM leads WHERE legacy_permitted_user_ids IS NOT NULL"
    reader = postgre.create_command(select).execute_reader
    reader.each do |row|
      row["legacy_permitted_user_ids"].split(",").each do |id|
        account_id = row["id"]
        sql = "INSERT INTO lead_permitted_users (lead_id, permitted_user_id) " <<
          "values (#{account_id}, (SELECT id FROM users WHERE legacy_id = '#{id}' LIMIT 1))"
        postgre.create_command(sql).execute_non_query
      end
    end

    # Migrate the trackers...
    select = "SELECT id, legacy_tracker_ids FROM leads WHERE legacy_tracker_ids IS NOT NULL"
    reader = postgre.create_command(select).execute_reader
    reader.each do |row|
      row["legacy_tracker_ids"].split(",").each do |id|
        account_id = row["id"]
        sql = "INSERT INTO lead_trackers (lead_id, tracker_id) " <<
          "values (#{account_id}, (SELECT id FROM users WHERE legacy_id = '#{id}' LIMIT 1))"
        postgre.create_command(sql).execute_non_query
      end
    end
  end

  def self.down
    sql = "UPDATE leads SET user_id = NULL, assignee_id = NULL, contact_id = NULL, updater_id = NULL"
    postgre.create_command(sql).execute_non_query

    sql = "DELETE FROM lead_trackers"
    postgre.create_command(sql).execute_non_query
  end
end
