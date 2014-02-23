require 'spec_helper'

describe BurnPlan::Portfolio do
  let(:asset1) { double('asset1', :name => 'asset1', :value => 1_000) }
  let(:asset2) { double('asset2', :name => 'asset2', :value => 2_000) }
  let(:portfolio) do
    BurnPlan::Portfolio.new({
      'asset1' => asset1,
      'asset2' => asset2,
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

  describe '#take_distribution' do
    let(:distribution) { double('distribution') }

    subject { portfolio.take_distribution(distribution) }

    it 'takes out the right amount' do
      distribution.should_receive(:for_asset).and_return(100)
      distribution.should_receive(:for_asset).and_return(200)
      asset1_result = double('asset1', :name => 'asset1', :value => 900, :kind_of? => true)
      asset2_result = double('asset2', :name => 'asset2', :value => 1_800, :kind_of? => true)
      asset1.should_receive(:take_distribution).with(100).and_return(asset1_result)
      asset2.should_receive(:take_distribution).with(200).and_return(asset2_result)
      subject.assets.should == { 'asset1' => asset1_result, 'asset2' => asset2_result }
    end

    it 'does not change the original portfolio' do
      portfolio.assets.should == { 'asset1' => asset1, 'asset2' => asset2 }
    end
  end

  describe '#execute_trades' do
    let(:trades) {
      BurnPlan::TradesBuilder.new
      .add_trade(BurnPlan::Trade.new('asset1', 100))
      .add_trade(BurnPlan::Trade.new('asset2', -100))
      .build
    }

    subject { portfolio.execute_trades(trades) }

    it 'ends up with the right amounts' do
      asset1_result = double('asset1', :name => 'asset1', :value => 1100, :kind_of? => true)
      asset2_result = double('asset2', :name => 'asset2', :value => 900, :kind_of? => true)
      asset1.should_receive(:trade).with(100).and_return(asset1_result)
      asset2.should_receive(:trade).with(-100).and_return(asset2_result)
      subject.assets.should == { 'asset1' => asset1_result, 'asset2' => asset2_result }
    end
  end
end
