module BurnPlan
  class TradesBuilder
    def initialize
      @trades = {}
    end

    def add_trade(trade)
      raise Exception.new("trade for asset #{trade.asset_name} already exists") if @trades.include? trade.asset_name
      @trades[trade.asset_name] = trade
      self
    end

    def build
      Trades.new(@trades)
    end
  end

  class Trades
    attr_reader :trades

    def initialize(trades)
      # TODO: should we enforce only 1 trade per asset here? similarly or distribution, 1
      # distribution per asset, etc? maybe later with retirement accounts and things like that
      # it'll start get complicated so punting for now. also if we do it, does it make more sense
      # to enforce it here or in the builder?
      @trades = trades
    end

    def for_asset(asset)
      @trades[asset.name]
    end

    def amount
      sum = 0
      @trades.values.each do |trade|
        sum += trade.amount
      end
      sum
    end
  end
end
