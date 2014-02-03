module BurnPlan
  # represents the economic activity during a time period
  class ReturnsBuilder
    def initialize(inflation)
      @asset_classes = {}
      @inflation = inflation
    end

    def add_return(asset_class, asset_return)
      @asset_classes[asset_class.name] = asset_return
      self
    end

    def build
      Returns.new(@asset_classes, @inflation)
    end
  end

  class Returns
    def initialize(asset_classes, inflation)
      @asset_classes = asset_classes
      @inflation = inflation
    end

    # applies the economic activity during this time period to an asset
    # and returns a new asset
    def apply(asset)
      nominal_rate = @asset_classes[asset.name]
      real_rate = @inflation.real_return(nominal_rate)
      next_value = asset.value * (1 + real_rate)
      asset.class.new(asset.name, next_value)
    end
  end
end
