shared_examples 'All Built Objects' do |object_type|
  context 'All built objects' do
    it { should_not be_nil }
    it { should be_valid }
    it "should be kind of #{object_type}" do
      should be_kind_of(object_type)
    end
  end
end
