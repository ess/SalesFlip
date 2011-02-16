require 'test_helper.rb'

class EmailTest < ActiveSupport::TestCase
  context 'Class' do
    should_require_key :subject, :text, :received_at, :from
  end

  context 'Instance' do
    setup do
      @email = Email.make_unsaved(:erich_offer_email)
    end

    should 'return subject for name' do
      assert @email.subject == @email.name
    end
  end
end
