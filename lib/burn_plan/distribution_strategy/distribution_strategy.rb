module BurnPlan
  module DistributionStrategy
    class DistributionStrategy
      def initialize

      end

      def create_distribution(portfolio, years_from_now)
        raise NotImplementedError
      end
    end
  end
end
