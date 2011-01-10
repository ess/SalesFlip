Given /^I follow the edit link for the lead$/ do
  click_link "edit_lead_#{Lead.last.id}"
end

Given /^I have accepted an invitation from annika$/ do
  annika = model!('annika')
  invitation = Invitation.make(:inviter => annika, :email => 'test@test.com',
                               :role => 'Freelancer')
  freelancer = User.make :invitation_code => invitation.code,
    :email => 'test@test.com', :username => 'test', :role => 'Freelancer'
  freelancer.confirm!
  store_model('user', 'user', freelancer)
  visit new_user_session_path
  fill_in 'user_email', :with => 'test@test.com'
  fill_in 'user_password', :with => 'password'
  click_link_or_button 'user_submit'
end

Given /I execute "([^\"]*)"$/ do |command|
  eval command
end

Given /#{capture_model} belongs to the same company as #{capture_model}$/ do |user1, user2|
  u1 = model!(user1)
  u2 = model!(user2)
  u1.update_attributes :company_id => u2.company_id
end

Given /^I am registered and logged in as benny$/ do
  visit new_user_path
  fill_in_registration_form(:email => 'benjamin.pochhammer@1000jobboersen.de')
  click_link_or_button 'user_submit'
  visit user_confirmation_path(:confirmation_token =>
                               User.last.confirmation_token)
  store_model('user', 'benny', User.last)
end

Given /^I login as #{capture_model}$/ do |user|
  m = model!(user)
  m.update_attributes :confirmed_at => Time.now
  visit new_user_session_path
  fill_in_login_form(:email => m.email)
  click_link_or_button 'user_submit'
end

Given /^erich is shared with annika$/ do
  lead = Lead.where(:first_name => 'Erich').first
  user = User.where(:email => 'annika.fleischer@1000jobboersen.de').first
  lead.update_attributes :permitted_user_ids => [user.id], :permission => 'Shared'
end

Given /^markus is not shared with annika$/ do
  lead = Lead.where(:first_name => 'Markus').first
  lead.update_attributes :permitted_user_ids => [lead.user_id], :permission => 'Shared'
end

Given /^inspect #{capture_model}$/ do |model|
  m = model!(model)
  puts m.inspect
end

Given /^the lead is shared with the other user$/ do
  lead = model!('lead')
  user = model!('user')
  lead.update_attributes :permission => 'Shared', :permitted_user_ids => [user.id]
end

Given /^#{capture_model} accepts the lead$/ do |model|
  Lead.last.update_attributes :assignee => model!(model)
end

Then /^an activity should have been created with for lead: "([^\"]*)" and user: "([^\"]*)"$/ do |arg1, arg2|
  lead = model!(arg1)
  user = model!(arg2)
  assert lead.activities.any? {|a| a.user == user }
end

Then /^#{capture_model} should be observing the #{capture_model}$/ do |user, trackable|
  t = model!(trackable)
  u = model!(user)
  assert t.tracked_by?(u)
end

Then /^#{capture_model} should not be observing the #{capture_model}$/ do |user, trackable|
  t = model!(trackable)
  u = model!(user)
  assert !t.tracker_ids.include?(u.id)
end

Then /^a task should have been created$/ do
  assert_equal 1, Task.count
end

Then /^a created activity should exist for lead with first_name "([^\"]*)"$/ do |first_name|
  assert Activity.first(:conditions => { :action => 'Created' }).
    subject.first_name == first_name
end

Then /^an updated activity should exist for lead with first_name "([^\"]*)"$/ do |first_name|
  assert Activity.first(:conditions => { :action => 'Updated' }).
    subject.first_name == first_name
end

Then /^a view activity should have been created for lead with first_name "([^\"]*)"$/ do |first_name|
  assert Activity.first(:conditions => { :action => 'Viewed' }).
    subject.first_name == first_name
end

Then /^a new "([^\"]*)" activity should have been created for "([^\"]*)" with "([^\"]*)" "([^\"]*)"$/ do |action, model, field, value|
  model = model.constantize.first(field => value)

  assert model.activities.first(:action => action)
end

Then /^a new "([^\"]*)" activity should have been created for "([^\"]*)" with "([^\"]*)" "([^\"]*)" and user: "([^\"]*)"$/ do |action, model, field, value, modifier|
  user = model!(modifier)
  model = model.constantize.first(field => value)
  assert model.activities.first(:action => action, :user => user)
end

Then /^lead "([^\"]*)" should have been deleted$/ do |lead|
  l = Lead.first
  assert l.deleted_at
end

When /^I POST attributes for lead: "([^\"]*)" to (.+)$/ do |blueprint_name, page_name|
  annika = model!('annika')
  attributes = Lead.plan(blueprint_name.to_sym).delete_if {|k,v| k.to_s == 'user_id' }.to_xml(:root => 'lead')
  post "#{path_to(page_name)}.xml", attributes,
    { 'Authorization' => 'Basic ' + ["#{annika.email}:password"].pack('m').delete("\r\n"),
      'Content-Type' => 'application/xml' }
end

Then /^#{capture_model} should be assigned to #{capture_model}$/ do |lead, user|
  lead = model!(lead)
  user = model!(user)
  assert_equal user, lead.assignee
end
