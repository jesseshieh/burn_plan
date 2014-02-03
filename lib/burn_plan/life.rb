module BurnPlan
  class Life
    attr_reader :ending_portfolio_value

    def initialize(portfolio, num_years_to_simulate, economy, federal_reserve)
      @original_portfolio = portfolio
      @num_years_to_simulate = num_years_to_simulate
      @economy = economy
      @federal_reserve = federal_reserve
      reset
    end

    def live
      @num_years_to_simulate.times do |year|
        @portfolio = @portfolio.next(@economy, @federal_reserve)
      end
      @ending_portfolio_value = @portfolio.value
    end

    def reset
      @portfolio = @original_portfolio
      @ending_portfolio_value = nil
    end
  end
end

