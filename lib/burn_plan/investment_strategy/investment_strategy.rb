module BurnPlan
  module InvestmentStrategy
    class InvestmentStrategy
      def initialize
      end

      def create_investments(portfolio, year)
        raise NotImplementedError
      end
    end
  end
end
