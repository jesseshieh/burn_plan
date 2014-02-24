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

    def execute_trades(trades)
      # TODO: account for cash left over somehow, right now we assume cash left over
      # is just dropped on the floor and lost (maybe taken as a distribution)
      next_portfolio = PortfolioBuilder.new
      @assets.values.each do |current_asset|
        trade = trades.for_asset(current_asset)
        unless trade
          # no trade found, keep existing asset
          next_portfolio.add_asset(current_asset)
          next
        end
        next_asset = current_asset.trade(trade.amount)
        next_portfolio.add_asset(next_asset)
      end
      next_portfolio.build
    end

    private

    def trade(asset_name, amount)

    end

    def buy(asset_name, amount)

    end

    def sell(asset_name, amount)

    end
  end
end

