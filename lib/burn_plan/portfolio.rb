module BurnPlan
  class PortfolioBuilder
    def initialize
      @asset_classes = {}
    end

    def add_asset(asset)
      raise Exception.new('you must pass in an Asset') unless asset.kind_of? Asset
      @asset_classes[asset.name] = asset
      self
    end

    def build
      Portfolio.new(@asset_classes)
    end
  end

  # snapshot in time (balance sheet) of what you own
  class Portfolio
    def initialize(asset_classes)
      @asset_classes = asset_classes
    end

    def value
      @asset_classes.values.inject(0) {|sum, asset| sum += asset.value}
    end

    def next(economy, federal_reserve)
      # given an economy, what is the new portfolio after a time period?
      returns = economy.create_real_returns(federal_reserve)
      next_portfolio = PortfolioBuilder.new
      @asset_classes.values.each do |asset|
        next_asset = returns.apply(asset)
        next_portfolio.add_asset(next_asset)
      end
      next_portfolio.build
    end
  end
end

