module BurnPlan
  class Life
    attr_reader :ending_portfolio_value

    def initialize(portfolio, num_years_to_simulate, economy, federal_reserve, distribution_strategy)
      @original_portfolio = portfolio
      @num_years_to_simulate = num_years_to_simulate
      @economy = economy
      @federal_reserve = federal_reserve
      @distribution_strategy = distribution_strategy
      reset
    end

    def live
      @num_years_to_simulate.times do |year|
        @portfolio = @portfolio.next(@economy, @federal_reserve)
        distribution = @distribution_strategy.create_distribution(@portfolio)
        @portfolio = @portfolio.take_distribution(distribution)
      end
      @ending_portfolio_value = @portfolio.value
    end

    def reset
      @portfolio = @original_portfolio
      @ending_portfolio_value = nil
    end
  end
end
