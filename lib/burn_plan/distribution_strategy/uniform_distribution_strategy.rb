module BurnPlan
  module DistributionStrategy
    class UniformDistributionStrategy < DistributionStrategy
      def initialize(total_distribution_amount)
        @total_distribution_amount = total_distribution_amount
      end

      def create_distribution(portfolio)
        distribution_amount_per_asset = 1.0 * @total_distribution_amount / portfolio.assets.count
        distribution = DistributionBuilder.new
        portfolio.assets.values.each do |asset|
          # TODO: if one asset runs out of money, start taking from the other assets rather
          # than just throw your hands up and say you've run out of money
          distribution.add_asset Asset.new(asset.name, distribution_amount_per_asset)
        end
        distribution.build
      end
    end
  end
end
