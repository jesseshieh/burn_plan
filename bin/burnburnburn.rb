require 'burn_plan'
require 'json'
require 'digest/md5'

# find all permutuations of different asset classes
def asset_permutations(increment, portfolio_value, num_assets)
  raise ArgumentError, "increment must evenly divide portfolio value" if portfolio_value % increment != 0
  return [[portfolio_value]] if num_assets == 1
  result = []
  steps = (portfolio_value / increment).to_i + 1
  steps.times do |i|
    asset_value = increment * i
    remaining_portfolio_value = portfolio_value - asset_value
    permutations = asset_permutations(increment, remaining_portfolio_value, num_assets - 1)
    permutations.each do |permutation|
      result << [asset_value] + permutation
    end
  end
  result
end
permutations = asset_permutations(500.0, 3_000.0, 5)
portfolios = []
permutations.each do |permutation|
  raise unless permutation.sum == 3_000.0
  portfolio = BurnPlan::PortfolioBuilder.new
    .add_asset(BurnPlan::Asset.new('Large Company Stock',        permutation[0]))
    .add_asset(BurnPlan::Asset.new('Small Company Stocks',       permutation[1]))
    .add_asset(BurnPlan::Asset.new('Long-term Corporate Bonds',  permutation[2]))
    .add_asset(BurnPlan::Asset.new('Long Term Government Bonds', permutation[3]))
    .add_asset(BurnPlan::Asset.new('U.S. Treasury Bills',        permutation[4]))
    .build
  portfolios << portfolio
end
puts "Number of portfolios to run: #{portfolios.count}"

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

# construct our "world"
inflation_mean = 0.031
inflation_stddev = 0.043
federal_reserve = BurnPlan::FederalReserve.new(inflation_mean, inflation_stddev)

# from http://www.bogleheads.org/wiki/Historical_and_expected_returns
economy = BurnPlan::EconomyBuilder.new
  .add_asset_class(BurnPlan::AssetClass.new('Large Company Stock',        0.1230, 0.2020))
  .add_asset_class(BurnPlan::AssetClass.new('Small Company Stocks',       0.1740, 0.3290))
  .add_asset_class(BurnPlan::AssetClass.new('Long-term Corporate Bonds',  0.0620,	0.0850))
  .add_asset_class(BurnPlan::AssetClass.new('Long Term Government Bonds', 0.0550,	0.0570))
  .add_asset_class(BurnPlan::AssetClass.new('U.S. Treasury Bills',        0.0380,	0.0310))
  .build

json_economy = {}
economy.asset_classes.values.each do |asset_class|
  json_economy[asset_class.name] = {
    :mean => asset_class.mean,
    :stddev => asset_class.stddev,
  }
end

# TODO: maybe we shouldn't use floats for money. use int as cents instead with rounding
#portfolio = BurnPlan::PortfolioBuilder.new
#  .add_asset(BurnPlan::Asset.new('Large Company Stock',        1_000.0))
#  .add_asset(BurnPlan::Asset.new('Small Company Stocks',       1_000.0))
#  .add_asset(BurnPlan::Asset.new('Long-term Corporate Bonds',  0.0))
#  .add_asset(BurnPlan::Asset.new('Long Term Government Bonds', 1_000.0))
#  .add_asset(BurnPlan::Asset.new('U.S. Treasury Bills',        0.0))
#  .build

portfolios.each_with_index do |portfolio, i|
  puts "Running portfolio #{i + 1} of #{portfolios.count}"

  # set our life strategies
  capital_gains_tax_rate = 0.25
  tax_strategy = BurnPlan::TaxStrategy::CapitalGainsTaxStrategy.new(capital_gains_tax_rate)
  distribution_percentage = 0.03
  min_distribution = 70.0
  max_distribution = 100.0
  distribution_strategy = BurnPlan::DistributionStrategy::UniformPercentageDistributionStrategy.new(distribution_percentage, min_distribution, max_distribution, tax_strategy)
  rebalancing_strategy = BurnPlan::RebalancingStrategy::OptimalRebalancingStrategy.new(portfolio)

  num_years_to_live = 70
  num_simulations = 10_000
  life_factory = BurnPlan::LifeFactory.new(portfolio, num_years_to_live, economy, federal_reserve, distribution_strategy, rebalancing_strategy)

  # get the parameters
  json_assets = {}
  puts "Parameters:"
  portfolio.assets.values.each do |asset|
    puts "Asset: #{asset.name}: #{asset.value}"
    json_assets[asset.name] = asset.value
  end
  puts "Number of simulations to run: #{num_simulations}"
  puts "Number of years to live: #{num_years_to_live}"
  puts ""

  # run the simulations
  monte_carlo = BurnPlan::MonteCarlo.new(num_simulations, life_factory)
  results = monte_carlo.run

  # get the results
  puts "Results:"
  puts "Average ending portfolio value: #{results.ending_portfolio_values_mean.to_currency}"
  puts "Number of simulations where you ran out of money: #{results.ending_portfolio_values_num_zeros}"
  puts "Likelihood you will run out of money: #{results.likelihood_of_running_out_of_money}"
  puts "Average yearly distribution taken: #{results.average_distribution}"
  puts ""

  File.open('results.json', 'a') do |file|
    params = {
      :economy => json_economy,
      :assets => json_assets,
      :num_simulations => num_simulations,
      :num_years_to_live => num_years_to_live,
      :capital_gains_tax_rate => capital_gains_tax_rate,
      :distribution_percentage => distribution_percentage,
      :min_distribution => min_distribution,
      :max_distribution => max_distribution,
      :inflation_mean => inflation_mean,
      :inflation_stddev => inflation_stddev
    }
    digest = Digest::MD5.hexdigest(params.to_json)
    params[:md5_digest] = digest

    result_data = {
      :ending_portfolio_values_mean => results.ending_portfolio_values_mean,
      :ending_portfolio_values_num_zeros => results.ending_portfolio_values_num_zeros,
      :likelihood_of_running_out_of_money => results.likelihood_of_running_out_of_money,
      :average_distribution => results.average_distribution,
    }

    file.write result_data.merge(params).to_json
    file.write "\n"
  end
end

