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
      ret = @random_gaussian.rand
      return -1.0 if ret < -1.0
      ret
    end
  end
end
