module BurnPlan
  class Asset
    attr_reader :value, :name

    def initialize(name, value)
      @name = name
      @value = value
    end

    def take_distribution(value)
      next_value = @value - value
      raise NotEnoughMoneyException.new("not enough value to distribute: #{value} from #{@value}") unless next_value >= 0
      Asset.new(@name, next_value)
    end
  end
end
