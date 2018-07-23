module BurnPlan
  module DistributionStrategy
    class ExplicitDistributionStrategy < DistributionStrategy
      def initialize(tax_strategy, down_payment, mortgage_monthly, home_price)
        @tax_strategy = tax_strategy
        @down_payment = down_payment
        @mortgage_monthly = mortgage_monthly
        @home_price = home_price
      end

      def create_distribution(portfolio, years_from_now)
        distribution_amount = get_total_distribution_amount(years_from_now)
        if distribution_amount > portfolio.value
          raise NotEnoughMoneyException.new("not enough value to distribute: #{distribution_amount} from #{portfolio.value}")
        end

        distribution_percentage = 1.0 * distribution_amount / portfolio.value

        trades = TradesBuilder.new
        portfolio.assets.values.each do |asset|
          case asset.name
          when 'Large Company Stock'
            asset_distribution_amount = 0.30 * distribution_amount
          when 'Small Company Stocks'
            asset_distribution_amount = 0.10 * distribution_amount
          when 'Long Term Government Bonds'
            asset_distribution_amount = 0.45 * distribution_amount
          when 'Foreign Stocks'
            asset_distribution_amount = 0.15 * distribution_amount
          else
            asset_distribution_amount = 0.0
          end

          next unless asset_distribution_amount > 0
          # TODO: this does each asset individually, might make sense to pay the taxes from a different asset
          # in some cases. that's an optimization though for later
          # asset_distribution_amount = asset.value * distribution_percentage
          pretax_distribution_amount = @tax_strategy.pretax_distribution_amount(asset, asset_distribution_amount)
          if pretax_distribution_amount > asset.value
            raise NotEnoughMoneyException.new("not enough value to distribute: #{asset.name}: #{pretax_distribution_amount} from #{asset.value}")
          end
          trades.add_trade Trade.new(asset.name, -1.0 * pretax_distribution_amount)
        end
        trades.build
      end

      def get_total_distribution_amount(year)
        raise Exception.new("years must be >= 0") unless year >= 0
        expenses = 0
        expenses += 1 # credit card expenses
        expenses += 0 if year < 20 # kids
        expenses += 0 if year < 20 # other dependents
        expenses += @down_payment if year == 0
        expenses += @mortgage_monthly * 12 if year < 30 # 30yr fixed mortgage
        expenses += @home_price * 0.025 # property tax cook county IL
        expenses += @home_price * 0.01 # est maintenance

        expenses
      end
    end
  end
end
