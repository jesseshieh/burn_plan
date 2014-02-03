module BurnPlan
  class Asset
    attr_reader :value, :name

    def initialize(name, value)
      @name = name
      @value = value
    end
  end
end
