require 'spec_helper'

describe BurnPlan::MonteCarloResults do
  let(:distribution_histories) { [[100, 200], [300, 400]] }

  describe '#ending_portfolio_values_mean' do
    let(:ending_portfolio_values) { [4, 6] }
    subject { described_class.new(ending_portfolio_values, distribution_histories) }

    it 'is correct' do
      subject.ending_portfolio_values_mean.should eq 5
    end
  end

  describe '#ending_portfolio_values_num_zeros' do
    let(:ending_portfolio_values) { [0, 4, 6, 0] }
    subject { described_class.new(ending_portfolio_values, distribution_histories) }

    it 'is correct' do
      subject.ending_portfolio_values_num_zeros.should eq 2
    end
  end

  describe '#likelihood_of_running_out_of_money' do
    let(:ending_portfolio_values) { [0, 4, 6, 0] }
    subject { described_class.new(ending_portfolio_values, distribution_histories) }

    it 'is correct' do
      subject.likelihood_of_running_out_of_money.should eq 0.5
    end
  end

  describe '#average_distribution' do
    let(:ending_portfolio_values) { [0, 4, 6, 0] }
    subject { described_class.new(ending_portfolio_values, distribution_histories) }

    it 'is correct' do
      subject.average_distribution.should eq 250
    end
  end
end
