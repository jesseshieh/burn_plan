require 'spec_helper'

describe BurnPlan::Portfolio do
  let(:portfolio) do
    BurnPlan::Portfolio.new({
      'asset1' => BurnPlan::Asset.new('asset1', 1_000),
      'asset2' => BurnPlan::Asset.new('asset2', 1_000)
    })
  end
  let(:returns) { double('returns') }
  let(:economy) { double('economy', {
      :create_real_returns => returns
  }) }
  let(:federal_reserve) { double('federal_reserve') }

  describe '#next' do
    it 'creates the next years portfolio' do
      p = portfolio
      asset = BurnPlan::Asset.new('fake-asset', 1)
      BurnPlan::Portfolio.should_receive(:new).with({
        'fake-asset' => asset
      }).and_return('fake-portfolio')
      returns.should_receive(:apply).twice.and_return(asset)
      p.next(economy, federal_reserve).should eq 'fake-portfolio'
    end
  end
end
