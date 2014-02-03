module BurnPlan
  class MonteCarlo
    attr_reader :ending_portfolio_values

    def initialize(num_simulations, life)
      @num_simulations = num_simulations
      @life = life
      @ending_portfolio_values = []
    end

    def run
      @num_simulations.times do |i|
        @life.live
        @ending_portfolio_values << @life.ending_portfolio_value
        @life.reset
      end
    end
  end
end
