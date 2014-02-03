module BurnPlan
  class Simulator
    def initialize(portfolio, num_years_to_simulate, economy, federal_reserve)
      @portfolio = portfolio
      @num_years_to_simulate = num_years_to_simulate
      @economy = economy
      @federal_reserve = federal_reserve
    end

    def run
      @num_years_to_simulate.times do |year|
        @portfolio = @portfolio.next(@economy, @federal_reserve)
      end
      @portfolio.value
    end
  end
end

