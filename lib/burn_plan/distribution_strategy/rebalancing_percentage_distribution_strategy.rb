module BurnPlan
  module DistributionStrategy
    class RebalancingPercentageDistributionStrategy < DistributionStrategy
      def initialize(distribution_percentage, minimum_distribution, maximum_distribution, portfolio_rebalancing_strategy)
        @distribution_percentage = distribution_percentage
        @minimum_distribution = minimum_distribution
        @maximum_distribution = maximum_distribution
        @portfolio_rebalancing_strategy = portfolio_rebalancing_strategy
      end

      def create_distribution(portfolio)
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
        distribution.build
      end
    end
  end
end
