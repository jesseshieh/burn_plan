module BurnPlan
  class Asset
    attr_reader :amount

    def initialize(amount)
      @amount = amount
      @random_gaussian = RandomGaussian.new(return_mean, return_stddev)
    end

    def return_mean
      raise NotImplementedError
    end

    def return_stddev
      raise NotImplementedError
    end

    def next_return
      @random_gaussian.rand
    end
  end
end
