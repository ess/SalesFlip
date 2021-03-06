Given /^the following tasks:$/ do |tasks|
  Tasks.create!(tasks.hashes)
end

When /^I follow the edit link for the task$/ do
  click_link_or_button "edit_task_#{Task.last.id}"
end

When /^I delete the (\d+)(?:st|nd|rd|th) tasks$/ do |pos|
  visit tasks_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link_or_button "Destroy"
  end
end

When /^I check #{capture_model}$/ do |task|
  task = model!(task)
  check "task_#{task.id}"
end

Then /^I should see the following tasks:$/ do |expected_tasks_table|
  expected_tasks_table.diff!(tableish('table tr', 'td,th'))
end

Then /^the task "(.+)" should have been completed$/ do |name|
  assert Task.where(:name => name).first.completed?
end

Then /^a task re\-assignment email should have been sent to "([^\"]*)"$/ do |email_address|
  assert ActionMailer::Base.deliveries.any? do |d|
    d.to.include?(email_address) && d.body.match(/\/#{Task.last.asset.asset_type.downcase.pluralize}\//)
  end
end

Then /^(\d+) tasks should have been created$/ do |count|
  assert_equal count.to_i, Task.count
end

Then /^there should be (\d+) tasks? assigned to #{capture_model}$/ do |count, user|
  user = model!(user)
  Task.for(user).count.should == count.to_i
end
