require 'rails_helper'

describe Spree::Tenant, type: :model do

  context 'validations' do
    before do
      FactoryBot.create(:tenant)
    end
    it { should validate_uniqueness_of(:domain) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:domain) }
    it { should validate_presence_of(:code) }
  end

end
