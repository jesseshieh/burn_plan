require 'spec_helper'

describe BurnPlan::AssetClass do
  let(:mean) { 0.10 }
  let(:stddev) { 0.20 }

  subject { described_class.new("fake-name", mean, stddev) }

  describe '#next' do
    it 'produces expected mean and stddev' do
      results = []
      n = 10_000

      n.times do
        results << subject.next
      end
      sum = results.inject(0) {|sum, result| sum += result}
      mean = (1.0 * sum / n)
      mean.should be_within(0.01).of 0.1

      numerator = 0
      results.each do |result|
        numerator += (result - mean) ** 2
      end
      stddev = Math.sqrt(1.0 * numerator / n)
      stddev.should be_within(0.01).of 0.2
    end
  end
end
