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
    monte_carlo_results_builder = double('monte carlo results builder')
    BurnPlan::MonteCarloResultsBuilder.should_receive(:new).and_return(monte_carlo_results_builder)
    monte_carlo_results_builder.should_receive(:add_result).exactly(num_simulations).times
    monte_carlo_results_builder.should_receive(:build).and_return('fake-results')
    life.should_receive(:live).exactly(num_simulations).times
    subject.run.should eq 'fake-results'
  end
end
