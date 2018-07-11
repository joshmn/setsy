require 'spec_helper'

describe Setsy do
  before :all do
    @new_user = User.new(:name => "Bob")
    @user = User.create(:name => "John", :settings_data => {:posts_limit => 50, :marketing_emails => true, :color => 'green'})
  end
  describe '#settings' do
    it 'is responded to' do
      expect(@new_user).to respond_to(:settings)
    end
    it 'have four attributes' do
      expect(@new_user.settings.attributes.keys).to eq([:posts_limit, :marketing_emails, :color, :posts_and_marketing])
    end
    describe 'attribute' do
      it 'has a value' do
        expect(@new_user.settings.posts_limit.value).to eq(10)
        expect(@new_user.settings.color.value).to eq('blue')
      end
      it 'behaves like a string' do
        expect("#{@new_user.settings.posts_limit}").to eq("10")
      end
      it 'has a default' do
        expect(@new_user.settings.posts_limit.default?).to be_truthy
      end
    end
    describe 'reader attribute' do
      it 'returns what it is supposed to' do
        expect(@new_user.settings.posts_and_marketing).to eq("User has 10 post limit and marketing emails are false")
        expect(@user.settings.posts_and_marketing).to eq("User has 50 post limit and marketing emails are true")
      end
    end
  end
end