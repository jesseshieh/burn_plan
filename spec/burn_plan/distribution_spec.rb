require 'spec_helper'

describe BurnPlan::Distribution do
  describe '#for_asset' do
    let(:asset) { double('portfolio asset1', {
        :name => 'asset1'
    })}
    let(:assets) do
      {
        'asset1' => double('distribution asset1', :name => 'asset1', :value => 3)
      }
    end
    subject { described_class.new(assets) }

    it 'returns the value' do
      subject.for_asset(asset).should eq 3
    end

    context 'when the asset does not exist' do
      let(:asset) { double('portfolio asset2', {
          :name => 'asset2'
      })}

      it 'raises' do
        expect { subject.for_asset(asset) }.to raise_exception
      end
    end
  end
end
