require 'spec_helper'

describe BurnPlan::MonteCarloResults do
  describe '#mean' do
    let(:results) { [4, 6] }
    subject { described_class.new(results) }

    it 'is correct' do
      subject.mean.should eq 5
    end
  end

  describe '#num_zeros' do
    let(:results) { [0, 4, 6, 0] }
    subject { described_class.new(results) }

    it 'is correct' do
      subject.num_zeros.should eq 2
    end
  end

  describe '#likelihood_of_running_out_of_money' do
    let(:results) { [0, 4, 6, 0] }
    subject { described_class.new(results) }

    it 'is correct' do
      subject.likelihood_of_running_out_of_money.should eq 0.5
    end
  end
end
