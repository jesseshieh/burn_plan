require 'spec_helper'

describe BurnPlan::Distribution do
  let(:asset) { double('portfolio asset1', {
    :name => 'asset1'
  })}
  let(:assets) do
    {
      'asset1' => double('distribution asset1', :name => 'asset1', :value => 3),
      'asset2' => double('distribution asset2', :name => 'asset2', :value => 4)
    }
  end
  subject { described_class.new(assets) }

  describe '#for_asset' do
    it 'returns the value' do
      subject.for_asset(asset).should eq 3
    end

    context 'when the asset does not exist' do
      let(:asset) { double('portfolio asset3', {
          :name => 'asset3'
      })}

      it 'raises' do
        expect { subject.for_asset(asset) }.to raise_exception
      end
    end
  end

  describe "#amount" do
    it 'calculates the amount correctly' do
      subject.amount.should eq 7
    end
  end
end
