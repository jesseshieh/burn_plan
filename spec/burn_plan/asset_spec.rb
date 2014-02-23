require 'spec_helper'

describe BurnPlan::Asset do
  let(:starting_amount) { 6 }
  let(:amount) { 4 }
  let(:asset) { described_class.new('asset1', starting_amount) }

  shared_examples_for 'selling' do
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

    context 'with a negative amount' do
      let(:amount) { -4 }

      it 'raises an error' do
        expect { subject }.to raise_exception
      end
    end
  end

  describe "#take_distribution" do
    subject { asset.take_distribution(amount) }

    it_behaves_like "selling"
  end

  describe "#sell" do
    subject { asset.sell(amount) }

    it_behaves_like "selling"
  end

  describe "#buy" do
    subject { asset.buy(amount) }

    it 'takes out the right amount' do
      subject.value.should eq 10
    end

    it 'does not change original' do
      asset.value.should eq starting_amount
    end

    context 'with a negative amount' do
      let(:amount) { -4 }

      it 'raises an error' do
        expect { subject }.to raise_exception
      end
    end
  end

  describe "#trade" do
    subject { asset.trade(amount) }

    it 'takes out the right amount' do
      subject.value.should eq 10
    end

    it 'does not change original' do
      asset.value.should eq starting_amount
    end

    context 'with a negative amount' do
      let(:amount) { -4 }

      it 'takes out the right amount' do
        subject.value.should eq 2
      end

      it 'does not change original' do
        asset.value.should eq starting_amount
      end
    end
  end
end
