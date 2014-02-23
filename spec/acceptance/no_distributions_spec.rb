require 'spec_helper'

describe 'no distributions' do
  it 'has no zero portfolios' do
    federal_reserve = BurnPlan::FederalReserve.new(0.031, 0.043)

    economy = BurnPlan::EconomyBuilder.new
    .add_asset_class(BurnPlan::AssetClass.new('Large Company Stock', 0.123, 0.202))
    .add_asset_class(BurnPlan::AssetClass.new('Long Term Government Bonds', 0.055, 0.057))
    .build

    portfolio = BurnPlan::PortfolioBuilder.new
    .add_asset(BurnPlan::Asset.new('Large Company Stock', 1_000))
    .add_asset(BurnPlan::Asset.new('Long Term Government Bonds', 1_000))
    .build

    distribution_strategy = BurnPlan::DistributionStrategy::NoDistributionStrategy.new
    rebalancing_strategy = BurnPlan::RebalancingStrategy::NoRebalancingStrategy.new
    life_factory = BurnPlan::LifeFactory.new(portfolio, 70, economy, federal_reserve, distribution_strategy, rebalancing_strategy)

    monte_carlo = BurnPlan::MonteCarlo.new(100, life_factory)
    results = monte_carlo.run

    results.ending_portfolio_values_num_zeros.should eq 0
  end
end
