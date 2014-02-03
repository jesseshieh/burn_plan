require 'spec_helper'

describe BurnPlan::Returns do
  describe '#apply' do
    let(:asset) { BurnPlan::Asset.new('asset1', 1_000) }
    let(:asset_class1) { double('asset class 1') }
    let(:asset_classes) do
      {
        'asset1' => 0.1,
        'asset2' => 0.2,
      }
    end
    let(:inflation) { double('inflation', {
        :real_return => 0.03
    }) }
    subject { described_class.new(asset_classes, inflation) }

    it 'applies the return and returns a new asset' do
      inflation.should_receive(:real_return).with(0.1)
      next_asset = subject.apply(asset)
      next_asset.name.should eq 'asset1'
      next_asset.value.should eq 1_030
    end
  end
end
