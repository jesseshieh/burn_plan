module BurnPlan
  class AssetClass
    attr_reader :name, :mean, :stddev

    def initialize(name, mean, stddev)
      @name = name
      @mean = mean
      @stddev = stddev
      @random_gaussian = RandomGaussian.new(mean, stddev)
    end

    def next
      @random_gaussian.rand
    end
  end
end
