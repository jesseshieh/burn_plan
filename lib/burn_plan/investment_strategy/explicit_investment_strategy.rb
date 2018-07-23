module BurnPlan
  module InvestmentStrategy
    class ExplicitInvestmentStrategy < InvestmentStrategy
      def initialize(annual_income_after_tax, retirement_year)
        @annual_income_after_tax = annual_income_after_tax
        @retirement_year = retirement_year # years from now that you plan to retire
      end

      def create_investments(portfolio, year)
        income = get_income(year)
        trades = TradesBuilder.new
        portfolio.assets.values.each do |asset|
          case asset.name
          when 'Large Company Stock'
            trades.add_trade Trade.new(asset.name, income * 0.50)
          when 'Small Company Stocks'
            trades.add_trade Trade.new(asset.name, income * 0.10)
          when 'Long Term Government Bonds'
            trades.add_trade Trade.new(asset.name, income * 0.45)
          when 'Foreign Stocks'
            trades.add_trade Trade.new(asset.name, income * 0.15)
          end
        end
        trades.build
      end

      def get_income(year)
        income = 0
        income += @annual_income_after_tax if year < @retirement_year
        # Add any special stuff like equity here

        income
      end
    end
  end
end
