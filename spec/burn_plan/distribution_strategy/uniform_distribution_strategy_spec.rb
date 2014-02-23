require 'spec_helper'

describe BurnPlan::DistributionStrategy::UniformDistributionStrategy do
  let(:portfolio) do
    double('portfolio', {
        :assets => {
            'asset1' => BurnPlan::Asset.new('asset1', 9),
            'asset2' => BurnPlan::Asset.new('asset2', 9),
        }
    })
  end
  let(:distribution_amount) { 1 }

  subject { described_class.new(distribution_amount).create_distribution(portfolio) }

  it 'uniformly spreads out the distribution among the assets' do
    portfolio.assets.values.each do |asset|
      subject.for_asset(asset).should eq 0.5
    end
  end

  context 'with not enough money' do
    let(:distribution_amount) { 1000 }

    it 'raises an error' do
      expect { subject }.to raise_exception(BurnPlan::NotEnoughMoneyException)
    end
  end
end
