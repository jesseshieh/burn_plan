module BurnPlan
  class Asset
    attr_reader :value, :name

    def initialize(name, value)
      @name = name
      @value = value
    end

    def take_distribution(value)
      raise Exception.new("value can not be negative") if value < 0
      sell(value)
    end

    def sell(value)
      raise Exception.new("value can not be negative") if value < 0
      trade(-1.0 * value)
    end

    def buy(value)
      raise Exception.new("value can not be negative") if value < 0
      trade(value)
    end

    def trade(value)
      # negative value is a sell, positive value is a buy
      next_value = @value + value
      raise NotEnoughMoneyException.new("not enough value to distribute: #{value} from #{@value}") unless next_value >= 0
      Asset.new(@name, next_value)
    end
  end
end
