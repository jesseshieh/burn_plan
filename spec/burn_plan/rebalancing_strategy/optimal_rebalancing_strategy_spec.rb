require 'spec_helper'

describe BurnPlan::RebalancingStrategy::OptimalRebalancingStrategy do
  let(:original_portfolio) do
    double('original', {
      :assets => {
        'asset1' => BurnPlan::Asset.new('asset1', 100),
        'asset2' => BurnPlan::Asset.new('asset2', 300),
      },
      :value => 400
    })
  end
  let(:portfolio) do
    double('portfolio', {
      :assets => {
        'asset1' => BurnPlan::Asset.new('asset1', 500),
        'asset2' => BurnPlan::Asset.new('asset2', 500),
      },
      :value => 1000
    })
  end

  subject { described_class.new(original_portfolio).rebalance(portfolio) }

  it 'creates the right trades' do
    subject.for_asset(BurnPlan::Asset.new('asset1', 0)).amount.should == -250
    subject.for_asset(BurnPlan::Asset.new('asset2', 0)).amount.should == 250
  end
end
