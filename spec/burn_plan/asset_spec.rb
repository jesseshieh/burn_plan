require 'spec_helper'

describe BurnPlan::Asset do
  describe '#take_distribution' do
    let(:starting_amount) { 6 }
    let(:distribution_amount) { 4 }
    let(:asset) { described_class.new('asset1', starting_amount) }
    subject { asset.take_distribution(distribution_amount) }

    it 'takes out the right amount' do
      subject.value.should eq 2
    end

    it 'does not change original' do
      asset.value.should eq starting_amount
    end

    context 'when there is not enough to distribute' do
      let(:starting_amount) { 2 }

      it 'raises' do
        expect { subject }.to raise_exception
      end
    end
  end
end
