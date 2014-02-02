module BurnPlan
  class Simulator
    def initialize

    end

    def run
      portfolio = Portfolio.new()
      portfolio.add_asset LargeCompanyStocks.new(1_000)
      portfolio.add_asset LongTermGovernmentBonds.new(1_000)
    end
  end
end

