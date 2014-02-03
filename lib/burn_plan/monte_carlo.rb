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
        begin
          @life.live
          results.add_result @life.ending_portfolio_value
        rescue NotEnoughMoneyException
          # is 0 appropriate here? the entire portfolio may not necessarily be 0
          # this exception can be thrown if 1 single asset doesn't have enough money
          # for withdraw
          results.add_result 0
        end
      end
      results.build
    end
  end
end
