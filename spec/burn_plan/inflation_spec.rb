require 'spec_helper'

describe BurnPlan::Inflation do
  describe '#real_return' do
    let(:rate) { 0.03 }
    let(:nominal_return) { 0.1 }
    subject { described_class.new(rate).real_return(nominal_return) }

    it 'calculates real return' do
      subject.should be_within(0.0001).of 0.0679
    end
  end
end
