require 'spec_helper'

describe BurnPlan::Economy do
  let(:inflation) { BurnPlan::Inflation.new(0.03) }
  let(:federal_reserve) { double("federal reserve", {
      :create_inflation => inflation
  }) }
  let(:economy) do
    BurnPlan::Economy.new({
        'asset1' => BurnPlan::AssetClass.new('asset1', 0.1, 0.0),
        'asset2' => BurnPlan::AssetClass.new('asset2', 0.2, 0.0)
    })
  end

  describe "#create_real_returns" do
    subject { economy.create_real_returns(federal_reserve) }

    it 'generates returns' do
      BurnPlan::Returns.should_receive(:new).with({
          'asset1' => 0.1,
          'asset2' => 0.2
      }, inflation).and_return('fake-returns')
      subject.should eq 'fake-returns'
    end
  end
end
