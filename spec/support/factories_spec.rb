# require 'spec_helper'

# RSpec.describe 'Factory Girl' do
#   before { Timecop.freeze(Time.zone.parse('1/1/2012 8:00')) }

#   FactoryGirl.factories.map(&:name).each do |factory_name|
#     describe "#{factory_name} factory" do
#       # Test each factory
#       it 'is valid' do
#         factory = FactoryGirl.build(factory_name)
#         if factory.respond_to?(:valid?)
#           expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
#         end
#       end

#       # Test each trait
#       FactoryGirl.factories[factory_name].definition.defined_traits.map(&:name).each do |trait_name|
#         context "with trait #{trait_name}" do
#           it 'is valid' do
#             factory = FactoryGirl.build(factory_name, trait_name)
#             if factory.respond_to?(:valid?)
#               expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
#             end
#           end
#         end
#       end
#     end
#   end
# end
