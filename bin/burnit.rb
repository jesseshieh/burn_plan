require 'burn_plan'

# TODO: implement tax cost basis. requires multiple assets of the same class depending on when it was bought or sold
# TODO: implement correlation coefficients somehow. when 1 asset crashes other stend to crash with it
# TODO:
# TODO:

# construct our "world"
federal_reserve = BurnPlan::FederalReserve.new(0.031, 0.043)

# from http://www.bogleheads.org/wiki/Historical_and_expected_returns
economy = BurnPlan::EconomyBuilder.new
  .add_asset_class(BurnPlan::AssetClass.new('Large Company Stock',        0.1230, 0.2020))
  .add_asset_class(BurnPlan::AssetClass.new('Small Company Stocks',       0.1740, 0.3290))
  .add_asset_class(BurnPlan::AssetClass.new('Long-term Corporate Bonds',  0.0620,	0.0850))
  .add_asset_class(BurnPlan::AssetClass.new('Long Term Government Bonds', 0.0550,	0.0570))
  .add_asset_class(BurnPlan::AssetClass.new('U.S. Treasury Bills',        0.0380,	0.0310))
  .build

# TODO: maybe we shouldn't use floats for money. use int as cents instead with rounding
portfolio = BurnPlan::PortfolioBuilder.new
  .add_asset(BurnPlan::Asset.new('Large Company Stock',        1_000.0))
  .add_asset(BurnPlan::Asset.new('Small Company Stocks',       1_000.0))
  .add_asset(BurnPlan::Asset.new('Long-term Corporate Bonds',  0.0))
  .add_asset(BurnPlan::Asset.new('Long Term Government Bonds', 500.0))
  .add_asset(BurnPlan::Asset.new('U.S. Treasury Bills',        500.0))
  .build

# set our life strategies
#tax_strategy = BurnPlan::TaxStrategy::NoTaxStrategy.new
tax_strategy = BurnPlan::TaxStrategy::CapitalGainsTaxStrategy.new(0.25)
#distribution_strategy = BurnPlan::DistributionStrategy::NoDistributionStrategy.new
distribution_strategy = BurnPlan::DistributionStrategy::UniformPercentageDistributionStrategy.new(0.03, 70.0, 100.0, tax_strategy)
#rebalancing_strategy = BurnPlan::RebalancingStrategy::NoRebalancingStrategy.new
rebalancing_strategy = BurnPlan::RebalancingStrategy::OptimalRebalancingStrategy.new(portfolio)

# run the simulations
num_years_to_live = 70
life_factory = BurnPlan::LifeFactory.new(portfolio, num_years_to_live, economy, federal_reserve, distribution_strategy, rebalancing_strategy)

num_simulations = 1_000
monte_carlo = BurnPlan::MonteCarlo.new(num_simulations, life_factory)
results = monte_carlo.run

# get the results
class Numeric
  def to_currency( pre_symbol='$', thousands=',', decimal='.',
      post_symbol=nil )
    "#{pre_symbol}#{
    ( "%.2f" % self ).gsub(
        /(\d)(?=(?:\d{3})+(?:$|\.))/,
        "\\1#{thousands}"
    )
    }#{post_symbol}"
  end
end

puts "Average ending portfolio value: #{results.ending_portfolio_values_mean.to_currency}"
puts "Number of simulations where you ran out of money: #{results.ending_portfolio_values_num_zeros}"
puts "Likelihood you will run out of money: #{results.likelihood_of_running_out_of_money}"
puts "Average yearly distribution taken: #{results.average_distribution}"
