Given /^#{capture_model} (?:has|have) invited #{capture_model}$/ do |inviter, invited|
  inviter = model!(inviter)
  invited = create_model(invited, :company => inviter.company)
end
