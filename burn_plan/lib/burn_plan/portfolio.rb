module BurnPlan
  class Portfolio
    def initialize
      @holdings = {}
    end

    def add_asset(asset)
      raise Exception.new("you must pass in an Asset") unless asset.kind_of? Asset
      @holdings[asset.class] = asset
    end

    def next_returns
      @holdings.values.map do |asset|
        asset.next_return
      end
    end
  end
end

