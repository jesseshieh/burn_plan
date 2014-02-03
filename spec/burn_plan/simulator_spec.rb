require 'spec_helper'

describe BurnPlan::Simulator do
  describe '#run' do
    let(:num_years) { 8 }
    let(:portfolio) { double('portfolio', {
        :value => 10.0
    }) }
    let(:economy) { double('economy') }
    let(:federal_reserve) { double('federal reserve') }

    subject { described_class.new(portfolio, num_years, economy, federal_reserve ) }

    it 'calls the portfolio N times' do
      portfolio.should_receive(:next).exactly(num_years).times.and_return(portfolio)
      subject.run.should eq 10.0
    end
  end
end
