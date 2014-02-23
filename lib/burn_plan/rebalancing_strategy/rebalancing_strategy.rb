module BurnPlan
  module RebalancingStrategy
    class RebalancingStrategy
      def initialize

      end

      def rebalance(portfolio)
        raise NotImplementedError
      end
    end
  end
end
