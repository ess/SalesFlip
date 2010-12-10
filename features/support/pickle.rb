# this file generated by script/generate pickle [paths] [email]
#
# Make sure that you are loading your factory of choice in your cucumber environment
#
# For machinist add: features/support/machinist.rb
#
#    require 'machinist/active_record' # or your chosen adaptor
#    require File.dirname(__FILE__) + '/../../spec/blueprints' # or wherever your blueprints are
#    Before { Sham.reset } # to reset Sham's seed between scenarios so each run has same random sequences
#
# For FactoryGirl add: features/support/factory_girl.rb
#
#    require 'factory_girl'
#    require File.dirname(__FILE__) + '/../../spec/factories' # or wherever your factories are
#
# You may also need to add gem dependencies on your factory of choice in <tt>config/environments/cucumber.rb</tt>

require 'pickle/world'
# Example of configuring pickle:
#
Pickle.configure do |config|
  config.adapters = [:machinist]#, :active_record]
  config.map 'I', 'myself', 'me', 'my', :to => 'user: "me"'
  config.map 'annika', 'Annika',        :to => 'user: "annika"'
  config.map 'benny', 'Benny',          :to => 'user: "benny"'
  config.map 'careermee', 'CareerMee',  :to => 'account: "careermee"'
  config.map 'World Dating',            :to => 'account: "world_dating"'
  config.map 'erich', 'Erich',          :to => 'lead: "erich"'
  config.map 'florian', 'Florian',      :to => 'contact: "florian"'
  config.map '1000JobBoersen',          :to => 'company: "jobboersen"'
  config.map 'Carsten Werner',          :to => 'user: "carsten_werner"'
  config.map 'Matt',                    :to => 'user: "matt"'
  config.map 'Prospecting stage',       :to => 'opportunity stage: "prospecting"'
  config.map 'Negotiation stage',       :to => 'opportunity stage: "negotiation"'
  config.map 'Closed/Won stage',        :to => 'opportunity stage: "closed_won"'
  config.map 'generate_leads',          :to => 'campaign: "generate_leads"'
end
require 'pickle/path/world'
require 'pickle/email/world'
