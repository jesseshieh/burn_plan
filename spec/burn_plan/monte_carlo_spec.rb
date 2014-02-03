require 'spec_helper'

describe BurnPlan::MonteCarlo do
  let(:num_simulations) { 7 }
  let(:life) { double('life', {
      :live => nil,
      :reset => nil,
      :ending_portfolio_value => 3
  }) }

  subject { described_class.new(num_simulations, life) }

  it 'runs through the life N times' do
    life.should_receive(:live).exactly(num_simulations).times
    subject.run
    subject.ending_portfolio_values.should eq [3] * num_simulations
  end
end
