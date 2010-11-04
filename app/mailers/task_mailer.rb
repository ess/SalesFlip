class TaskMailer < ActionMailer::Base
  default :from => 'service@salesflip.com'

  def assignment_notification( task )
    @url = task_url(task)
    mail(:to => task.assignee.email, :subject => I18n.t('emails.task_reassigned.subject'),
         :reply_to => 'do-not-reply@salesflip.com')
  end

  def daily_task_summary( user, tasks )
    @tasks = tasks
    mail(:to => user.email, :reply_to => 'do-not-reply@salesflip.com',
         :subject => I18n.t('emails.daily_task_summary.subject', :date => Date.today.to_s(:long)))
  end
end