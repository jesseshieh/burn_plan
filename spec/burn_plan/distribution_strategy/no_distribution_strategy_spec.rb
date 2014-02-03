require 'spec_helper'

describe BurnPlan::DistributionStrategy::NoDistributionStrategy do
  let(:portfolio) do
    double('portfolio', {
        :assets => {
            'asset1' => BurnPlan::Asset.new('asset1', 10),
            'asset2' => BurnPlan::Asset.new('asset2', 0),
        }
    })
  end

  subject { described_class.new.create_distribution(portfolio) }

  it 'always returns zero' do
    portfolio.assets.values.each do |asset|
      subject.for_asset(asset).name.should eq asset.name
      subject.for_asset(asset).value.should eq 0
    end
  end
end
