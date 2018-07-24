module BurnPlan
  module DistributionStrategy
    # takes an equal percentage from all assets with minimum and maximum amounts
    # if 3% puts you in poverty or you can't make your mortage payments, you're forced
    # to take out more than 3%. also, there is no reason to take out more than you need
    # TODO: subclass this into a distribution strategy that takes a fixed dollar amount, but
    # draws from each asset proportionally instead of evenly. sort of like taking a salary of X
    # for the rest of your life, fixed, with no raises.
    class UniformPercentageDistributionStrategy < DistributionStrategy
      def initialize(total_distribution_percentage, minimum_distribution, maximum_distribution, tax_strategy)
        @total_distribution_percentage = total_distribution_percentage

        # these amounts don't need to account for inflation because the burn plan does everything in real returns
        # these represent after tax amounts
        @minimum_distribution = minimum_distribution
        @maximum_distribution = maximum_distribution

        @tax_strategy = tax_strategy
      end

      def create_distribution(portfolio, years_from_now)
        distribution_amount = get_total_distribution_amount(portfolio)
        if distribution_amount > portfolio.value
          raise NotEnoughMoneyException.new("not enough value to distribute: #{distribution_amount} from #{portfolio.value}")
        end

        distribution_percentage = 1.0 * distribution_amount / portfolio.value

        trades = TradesBuilder.new
        portfolio.assets.values.each do |asset|
          # TODO: this does each asset individually, might make sense to pay the taxes from a different asset
          # in some cases. that's an optimization though for later
          asset_distribution_amount = asset.value * distribution_percentage
          pretax_distribution_amount = @tax_strategy.pretax_distribution_amount(asset, asset_distribution_amount)
          if pretax_distribution_amount > asset.value
            raise NotEnoughMoneyException.new("not enough value to distribute: #{asset.name}: #{pretax_distribution_amount} from #{asset.value}")
          end
          trades.add_trade Trade.new(asset.name, -1.0 * pretax_distribution_amount)
        end
        trades.build
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
