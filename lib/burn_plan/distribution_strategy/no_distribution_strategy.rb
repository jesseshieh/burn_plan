module BurnPlan
  module DistributionStrategy
    class NoDistributionStrategy < DistributionStrategy
      def initialize

      end

      def create_distribution(portfolio)
        distribution = DistributionBuilder.new
        portfolio.assets.values.each do |asset|
          distribution.add_asset Asset.new(asset.name, 0)
        end
        distribution.build
      end
    end
  end
end
