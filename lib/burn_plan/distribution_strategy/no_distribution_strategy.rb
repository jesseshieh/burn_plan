module BurnPlan
  module DistributionStrategy
    class NoDistributionStrategy < DistributionStrategy
      def initialize

      end

      def create_distribution(portfolio, years_from_now)
        trades = TradesBuilder.new
        portfolio.assets.values.each do |asset|
          trades.add_trade Trade.new(asset.name, 0)
        end
        trades.build
      end
    end
  end
end
