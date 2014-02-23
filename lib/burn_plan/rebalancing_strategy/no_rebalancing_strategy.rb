module BurnPlan
  module RebalancingStrategy
    class NoRebalancingStrategy
      def initialize

      end

      def rebalance(portfolio)
        TradesBuilder.new.build # no trades
      end
    end
  end
end
