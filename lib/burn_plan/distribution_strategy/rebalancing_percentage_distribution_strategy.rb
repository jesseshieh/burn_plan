# TODO: this class is hard to write. you want to take a distribution as optimally as possible
# meaning don't sell an asset for distribution just to turn around and buy it again during
# rebalancing. this means calculating rebalancing and taxes before the distribution and figuring out
# what is "safe" to take out as distribution. it's sort of complex because you have to know your
# taxes beforehand, but that's hard to know, sort of a cyclic dependency. also during a rebalance,
# when you sell, you then have to buy something else. you have to make sure that after taking the
# distribution, you have the right amount of money so that when you buy the other asset, you end up
# with the exact right balance of assets. i'm punting on this for now until later. i want a working
# model before refining it into an optimal model.
module BurnPlan
  module DistributionStrategy
    class RebalancingPercentageDistributionStrategy < DistributionStrategy
      def initialize(distribution_percentage, minimum_distribution, maximum_distribution, portfolio_rebalancing_strategy)
        @distribution_percentage = distribution_percentage
        @minimum_distribution = minimum_distribution
        @maximum_distribution = maximum_distribution
        @portfolio_rebalancing_strategy = portfolio_rebalancing_strategy
      end

      def create_distribution(portfolio, years_from_now)
        transactions = @portfolio_rebalancing_strategy.rebalance(portfolio)
        sorted_transactions = transactions.sort_by {|x| x.amount }

        # figure out how much to distribute
        total_distribution_amount = portfolio.value * @distribution_percentage
        if total_distribution_amount < @minimum_distribution
          total_distribution_amount = @minimum_distribution
        elsif total_distribution_amount > @maximum_distribution
          total_distribution_amount = @maximum_distribution
        end

        # take from the top and go down until we don't need anymore
        distribution = DistributionBuilder.new
        sorted_transactions.each do |transaction|
          if transaction.amount < total_distribution_amount
            total_distribution_amount -= transaction.amount
            distribution.add_asset Asset.new(transaction.asset.name, transaction.amount)
          else
            total_distribution_amount -= total_distribution_amount
            distribution.add_asset Asset.new(transaction.asset.name, total_distribution_amount)
          end
        end

        # if there is still money left over, take from each asset evenly by percentage
        amount_left_to_distribute = total_distribution_amount
        percent_left_to_distribute = 1.0 * amount_left_to_distribute /
        portfolio.assets.each do |asset|
          # this means the total distribution may not be exactly the desired percentage, but it'll be close
          # maybe optimally close
          distribution.add_asset Asset.new(asset.name, asset.value * @distribution_percentage)
        end
        distribution.build
      end
    end
  end
end
