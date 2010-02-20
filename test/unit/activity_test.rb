require 'test_helper.rb'

class ActivityTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_constant :actions

    context 'log' do
      setup do
        @lead = Lead.make(:erich)
        Activity.delete_all
      end

      should 'create a new activity with the supplied user, model and action' do
        Activity.log(@lead.user, @lead, 'Viewed')
        assert_equal 1, Activity.count
        assert Activity.first(:conditions => { :user_id => @lead.user_id, :subject_id => @lead.id,
                              :subject_type => 'Lead', :action => Activity.actions.index('Viewed') })
      end

      should 'create a new activity for "Deleted"' do
        Activity.log(@lead.user, @lead, 'Deleted')
        assert @lead.activities.any? {|a| a.action == 'Deleted' }
      end

      should 'find and update the last activity if action is "Viewed"' do
        Activity.log(@lead.user, @lead, 'Viewed')
        activity = Activity.last(:order => 'created_at')
        updated_at = activity.updated_at
        activity2 = Activity.log(@lead.user, @lead, 'Viewed')
        assert_equal 1, Activity.count
        assert updated_at != activity2.updated_at
      end

      should 'find and update the last activity if action is "Commented"' do
        Activity.log(@lead.user, @lead, 'Commented')
        activity = Activity.last(:order => 'created_at')
        updated_at = activity.updated_at
        activity2 = Activity.log(@lead.user, @lead, 'Commented')
        assert_equal 1, Activity.count
        assert updated_at != activity2.updated_at
      end

      should 'find and update the last activity if action is "Updated"' do
        Activity.log(@lead.user, @lead, 'Updated')
        activity = Activity.last(:order => 'created_at')
        updated_at = activity.updated_at
        activity2 = Activity.log(@lead.user, @lead, 'Updated')
        assert_equal 1, Activity.count
        assert updated_at != activity2.updated_at
      end

      should 'NOT create "Viewed" activity for tasks' do
        task = Task.make(:call_erich)
        Activity.delete_all
        Activity.log(task.user, task, 'Viewed')
        assert_equal 0, Activity.count
      end
    end
  end

  context 'Instance' do
    setup do
      @activity = Activity.make_unsaved(:viewed_erich)
    end

    should 'be valid' do
      assert @activity.valid?
    end

    should 'be invalid without user_id' do
      @activity.user_id = nil
      assert !@activity.valid?
      assert @activity.errors.on(:user_id)
    end

    should 'be invalid without subject_id' do
      @activity.subject_id = nil
      assert !@activity.valid?
      assert @activity.errors.on(:subject_id)
    end

    should 'be invalid without subject_type' do
      @activity.subject_type = nil
      assert !@activity.valid?
      assert @activity.errors.on(:subject_type)
    end
  end
end
