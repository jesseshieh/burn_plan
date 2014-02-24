require 'spec_helper'

describe BurnPlan::DistributionStrategy::UniformPercentageDistributionStrategy do
  let(:portfolio) do
    double('portfolio', {
      :assets => {
        'asset1' => BurnPlan::Asset.new('asset1', 900),
        'asset2' => BurnPlan::Asset.new('asset2', 9000),
      },
      :value => 9900
    })
  end
  let(:distribution_percentage) { 0.1 }
  let(:minimum_amount) { 0 }
  let(:maximum_amount) { 999999 }

  subject { described_class.new(distribution_percentage, minimum_amount, maximum_amount).create_distribution(portfolio) }

  it 'uniformly spreads out the distribution among the assets by percentage' do
    portfolio.assets.values.each do |asset|
      (subject.for_asset(asset).amount / asset.value).should eq -1.0 * distribution_percentage
    end
  end

  context 'with a high minimum' do
    let(:minimum_amount) { 5000 }

    it 'uniformly spreads out the distribution evenly' do
      target_percentage = 1.0 * minimum_amount / 9900
      portfolio.assets.values.each do |asset|
        (subject.for_asset(asset).amount / asset.value).should eq -1.0 * target_percentage
      end
    end
  end

  context 'with a low maximum' do
    let(:maximum_amount) { 100 }

    it 'uniformly spreads out the distribution evenly' do
      target_percentage = 1.0 * maximum_amount / 9900
      portfolio.assets.values.each do |asset|
        (subject.for_asset(asset).amount / asset.value).should eq -1.0 * target_percentage
      end
    end
  end

  context 'not enough money' do
    let(:minimum_amount) { 99999 }

    it 'raises an exception' do
      expect { subject }.to raise_exception(BurnPlan::NotEnoughMoneyException)
    end
  end
end
