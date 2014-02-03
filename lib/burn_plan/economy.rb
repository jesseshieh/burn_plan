module BurnPlan
  class EconomyBuilder
    def initialize
      @asset_classes = {}
    end

    def add_asset_class(asset_class)
      raise Exception.new('you must pass in an AssetClass') unless asset_class.kind_of? AssetClass
      @asset_classes[asset_class.name] = asset_class
      self
    end

    def build
      Economy.new(@asset_classes)
    end
  end

  class Economy
    def initialize(asset_classes)
      @asset_classes = asset_classes
    end

    # generates 1 time period of returns
    def create_real_returns(federal_reserve)
      inflation = federal_reserve.create_inflation
      returns = Returns.new(inflation)
      @asset_classes.values.each do |asset_class|
        nominal_return = asset_class.next
        returns.add_return(asset_class, nominal_return)
      end
      returns
    end
  end
end
