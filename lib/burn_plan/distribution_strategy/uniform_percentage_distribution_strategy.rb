module BurnPlan
  module DistributionStrategy
    # takes an equal percentage from all assets with minimum and maximum amounts
    # if 3% puts you in poverty or you can't make your mortage payments, you're forced
    # to take out more than 3%. also, there is no reason to take out more than you need
    # TODO: subclass this into a distribution strategy that takes a fixed dollar amount, but
    # draws from each asset proportionally instead of evenly. sort of like taking a salary of X
    # for the rest of your life, fixed, with no raises.
    class UniformPercentageDistributionStrategy < DistributionStrategy
      def initialize(total_distribution_percentage, minimum_distribution, maximum_distribution)
        @total_distribution_percentage = total_distribution_percentage
        @minimum_distribution = minimum_distribution
        @maximum_distribution = maximum_distribution
      end

      def create_distribution(portfolio)
        distribution_amount = get_total_distribution_amount(portfolio)
        if distribution_amount > portfolio.value
          raise NotEnoughMoneyException.new("not enough value to distribute: #{distribution_amount} from #{portfolio.value}")
        end

        distribution_percentage = 1.0 * distribution_amount / portfolio.value

        distribution = DistributionBuilder.new
        portfolio.assets.values.each do |asset|
          distribution.add_asset Asset.new(asset.name, asset.value * distribution_percentage)
        end
        distribution.build
      end

      def get_total_distribution_amount(portfolio)
        total_distribution_amount = portfolio.value * @total_distribution_percentage
        if total_distribution_amount < @minimum_distribution
          total_distribution_amount = @minimum_distribution
        elsif total_distribution_amount > @maximum_distribution
          total_distribution_amount = @maximum_distribution
        end
        total_distribution_amount
      end
    end
  end
end
