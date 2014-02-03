require 'spec_helper'

describe BurnPlan::AssetClass do
  let(:mean) { 0.10 }
  let(:stddev) { 0.20 }
  let(:random_gaussian) { double('random gaussian', {
      :rand => 0.99
  }) }

  subject { described_class.new("fake-name", mean, stddev) }

  describe '#next' do
    it 'produces the next return' do
      BurnPlan::RandomGaussian.should_receive(:new).and_return(random_gaussian)
      subject.next.should eq 0.99
    end
  end
end
