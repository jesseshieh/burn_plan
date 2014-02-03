module BurnPlan
  class MonteCarlo
    attr_reader :ending_portfolio_values

    def initialize(num_simulations, life)
      @num_simulations = num_simulations
      @life = life
    end

    def run
      results = MonteCarloResultsBuilder.new
      @num_simulations.times do |i|
        @life.reset
        @life.live
        results.add_result @life.ending_portfolio_value
      end
      results.build
    end
  end
end
