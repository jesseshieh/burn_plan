module BurnPlan
  class FederalReserve
    def initialize(inflation_mean, inflation_stddev)
      @random_gaussian = RandomGaussian.new(inflation_mean, inflation_stddev)
    end

    def create_inflation
      Inflation.new(@random_gaussian.rand)
    end
  end
end
