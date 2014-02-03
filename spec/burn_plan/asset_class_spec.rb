require 'spec_helper'

describe BurnPlan::AssetClass do
  let(:mean) { 0.10 }
  let(:stddev) { 0.20 }
  let(:random_gaussian) { double('random gaussian', {
      :rand => 0.99
  }) }

  subject { described_class.new("fake-name", mean, stddev).next }

  describe '#next' do
    before do
      BurnPlan::RandomGaussian.should_receive(:new).and_return(random_gaussian)
    end

    it 'produces the next return' do
      subject.should eq 0.99
    end

    context 'when random gaussian is less than -100%' do
      let(:random_gaussian) { double('random gaussian', {
          :rand => -1.1
      }) }

      it 'uses -100%' do
        subject.should eq -1.0
      end
    end
  end
end

