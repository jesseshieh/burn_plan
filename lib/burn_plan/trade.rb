module BurnPlan
  class Trade
    attr_reader :amount, :asset_name

    def initialize(asset_name, amount)
      @asset_name = asset_name
      @amount = amount
    end
  end
end
