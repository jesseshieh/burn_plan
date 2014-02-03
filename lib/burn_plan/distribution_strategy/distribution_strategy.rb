module BurnPlan
  module DistributionStrategy
    class DistributionStrategy
      def initialize

      end

      def create_distribution(portfolio)
        raise NotImplementedError
      end
    end
  end
end
