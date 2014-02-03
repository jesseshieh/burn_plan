require 'spec_helper'

describe BurnPlan::Life do
  let(:num_years) { 8 }
  let(:portfolio) { double('portfolio', {
      :value => 10.0
  }) }
  let(:portfolio2) { double('portfolio2', {
      :value => 11.0
  }) }
  let(:economy) { double('economy') }
  let(:federal_reserve) { double('federal reserve') }
  let(:distribution_strategy) { double('distribution strategy', {
      :create_distribution => double('distribution')
  }) }

  subject { described_class.new(portfolio, num_years, economy, federal_reserve, distribution_strategy) }

  describe '#live' do
    it 'calls the portfolio N times' do
      portfolio.should_receive(:next).exactly(1).times.and_return(portfolio2)
      portfolio2.should_receive(:next).exactly(num_years - 1).times.and_return(portfolio2)
      portfolio2.should_receive(:take_distribution).exactly(num_years).times.and_return(portfolio2)
      subject.live.should eq 11.0
    end
  end

  describe '#reset' do
    it 'gets the same result both times' do
      portfolio.should_receive(:next).exactly(2).times.and_return(portfolio2)
      portfolio2.should_receive(:next).exactly(num_years * 2 - 2).times.and_return(portfolio2)
      portfolio2.should_receive(:take_distribution).exactly(num_years * 2).times.and_return(portfolio2)
      subject.live.should eq 11.0
      subject.reset
      subject.live.should eq 11.0
    end
  end
end