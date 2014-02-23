module BurnPlan
  module RebalancingStrategy
    class OptimalRebalancingStrategy
      def initialize(initial_portfolio)
        # we use the initial portfolio's asset allocation percentage as the target
        @initial_portfolio = initial_portfolio
      end

      def rebalance(portfolio)
        trades = TradesBuilder.new
        total_initial_portfolio_value = @initial_portfolio.value
        portfolio.assets.values.each do |asset|
          initial_portfolio_value = @initial_portfolio.assets[asset.name].value
          target_portfolio_percentage = 1.0 * initial_portfolio_value / total_initial_portfolio_value
          target_portfolio_value = target_portfolio_percentage * portfolio.value
          trades.add_trade Trade.new(asset.name, target_portfolio_value - asset.value)
        end
        trades.build
      end
    end
  end
end
