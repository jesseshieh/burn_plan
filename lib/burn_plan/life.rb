module BurnPlan
  class LifeFactory
    def initialize(original_portfolio, num_years_to_live, economy, federal_reserve, distribution_strategy, rebalancing_strategy)
      @original_portfolio = original_portfolio
      @num_years_to_live = num_years_to_live
      @economy = economy
      @federal_reserve = federal_reserve
      @distribution_strategy = distribution_strategy
      @rebalancing_strategy = rebalancing_strategy
    end

    def create
      Life.new(@original_portfolio, @num_years_to_live, @economy, @federal_reserve, @distribution_strategy, @rebalancing_strategy)
    end
  end

  class Life
    attr_reader :ending_portfolio_value, :distribution_history

    def initialize(portfolio, num_years_to_live, economy, federal_reserve, distribution_strategy, rebalancing_strategy)
      @portfolio = portfolio
      @num_years_to_live = num_years_to_live
      @economy = economy
      @federal_reserve = federal_reserve
      @distribution_strategy = distribution_strategy
      @rebalancing_strategy = rebalancing_strategy
      @ending_portfolio_value = nil
      @distribution_history = []
    end

    def live
      @num_years_to_live.times do |year|
        @portfolio = @portfolio.next(@economy, @federal_reserve)
        distribution = @distribution_strategy.create_distribution(@portfolio)
        @distribution_history << distribution.amount
        @portfolio = @portfolio.take_distribution(distribution)
        trades = @rebalancing_strategy.rebalance(@portfolio)
        @portfolio = @portfolio.execute_trades(trades)
      end
      @ending_portfolio_value = @portfolio.value
    end
  end
end
