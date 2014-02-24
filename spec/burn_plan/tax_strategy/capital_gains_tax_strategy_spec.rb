require 'spec_helper'

describe BurnPlan::TaxStrategy::CapitalGainsTaxStrategy do
  let(:tax_rate) { 0.25 }
  let(:asset) { double('asset') }
  let(:amount) { 75.0 }
  subject { described_class.new(tax_rate).pretax_distribution_amount(asset, amount) }

  describe '#pretax_distribution_amount' do
    it 'calculates the pretax amount' do
      subject.should == 100
    end

    context 'when tax rate is 0' do
      let(:tax_rate) { 0 }

      it 'calculates the pretax amount' do
        subject.should == 75
      end
    end

    context 'when tax rate is 1' do
      let(:tax_rate) { 1 }

      it 'calculates the pretax amount' do
        expect { subject }.to raise_exception(ArgumentError)
      end
    end

    context 'when tax rate is out of bounds' do
      let(:tax_rate) { -0.25 }

      it 'calculates the pretax amount' do
        expect { subject }.to raise_exception(ArgumentError)
      end
    end
  end
end
