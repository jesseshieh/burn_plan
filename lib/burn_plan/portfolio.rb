module BurnPlan
  class PortfolioBuilder
    def initialize
      @assets = {}
    end

    def add_asset(asset)
      raise Exception.new('you must pass in an Asset') unless asset.kind_of? Asset
      @assets[asset.name] = asset
      self
    end

    def build
      Portfolio.new(@assets)
    end
  end

  # snapshot in time (balance sheet) of what you own
  class Portfolio
    attr_reader :assets

    def initialize(assets)
      @assets = assets
    end

    def value
      @assets.values.inject(0) {|sum, asset| sum += asset.value}
    end

    def next(economy, federal_reserve)
      # given an economy, what is the new portfolio after a time period?
      returns = economy.create_real_returns(federal_reserve)
      next_portfolio = PortfolioBuilder.new
      @assets.values.each do |asset|
        next_asset = returns.apply(asset)
        next_portfolio.add_asset(next_asset)
      end
      next_portfolio.build
    end

    def take_distribution(distribution)
      next_portfolio = PortfolioBuilder.new
      @assets.values.each do |asset|
        next_asset = asset.take_distribution(distribution.for_asset(asset))
        next_portfolio.add_asset(next_asset)
      end
      next_portfolio.build
    end
  end
end

