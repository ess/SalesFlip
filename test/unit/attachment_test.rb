require 'test_helper.rb'

class AttachmentTest < ActiveSupport::TestCase
  context 'Class' do
    should_require_key :attachment
  end

  context 'Instance' do
    setup do
      @attachment = Attachment.make_unsaved(:erich_offer_pdf)
    end

    should 'be valid with all required attributes' do
      assert_valid @attachment
    end

    should 'not be valid without subject' do
      @attachment.subject = nil
      assert !@attachment.valid?
      assert @attachment.errors[:subject]
    end
  end
end
