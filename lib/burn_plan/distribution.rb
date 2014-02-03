module BurnPlan
  class DistributionBuilder
    def initialize
      @assets = {}
    end

    def add_asset(asset)
      @assets[asset.name] = asset
      self
    end

    def build
      Distribution.new(@assets)
    end
  end

  class Distribution
    def initialize(assets)
      @assets = assets
    end

    def for_asset(asset)
      @assets[asset.name].value or raise Exception.new("#{asset.name} distribution does not exist")
    end
  end
end
