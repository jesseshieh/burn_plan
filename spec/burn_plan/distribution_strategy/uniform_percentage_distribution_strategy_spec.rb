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
  let(:tax_strategy) {
    d = double('tax strategy')
    allow(d).to receive(:pretax_distribution_amount) do |asset, amount|
      amount
    end
    d
  }
  subject { described_class.new(distribution_percentage, minimum_amount, maximum_amount, tax_strategy).create_distribution(portfolio) }

  it 'uniformly spreads out the distribution among the assets by percentage' do
    expect(tax_strategy).to receive(:pretax_distribution_amount).twice
    portfolio.assets.values.each do |asset|
      (subject.for_asset(asset).amount / asset.value).should eq -1.0 * distribution_percentage
    end
  end

  context 'with a high minimum' do
    let(:minimum_amount) { 5000 }

    it 'uniformly spreads out the distribution evenly' do
      expect(tax_strategy).to receive(:pretax_distribution_amount).twice
      target_percentage = 1.0 * minimum_amount / 9900
      portfolio.assets.values.each do |asset|
        (subject.for_asset(asset).amount / asset.value).should eq -1.0 * target_percentage
      end
    end
  end

  context 'with a low maximum' do
    let(:maximum_amount) { 100 }

    it 'uniformly spreads out the distribution evenly' do
      expect(tax_strategy).to receive(:pretax_distribution_amount).twice
      target_percentage = 1.0 * maximum_amount / 9900
      portfolio.assets.values.each do |asset|
        (subject.for_asset(asset).amount / asset.value).should eq -1.0 * target_percentage
      end
    end
  end

  context 'not enough money' do
    let(:minimum_amount) { 99999 }

    it 'raises an exception' do
      expect(tax_strategy).not_to receive(:pretax_distribution_amount)
      expect { subject }.to raise_exception(BurnPlan::NotEnoughMoneyException)
    end
  end
end
