module BurnPlan
  module RebalancingStrategy
    class NoRebalancingStrategy < RebalancingStrategy
      def initialize

      end

      def rebalance(portfolio)
        TradesBuilder.new.build # no trades
      end
    end
  end
end
