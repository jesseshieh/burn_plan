module Enumerable
  def sum
    self.inject(0) { |accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m   = self.mean
    sum = self.inject(0) { |accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end

module BurnPlan
  class MonteCarloResultsBuilder
    def initialize
      @results = []
    end

    def add_result(result)
      @results << result
      self
    end

    def build
      MonteCarloResults.new(@results)
    end
  end

  class MonteCarloResults
    def initialize(ending_portfolio_values)
      @ending_portfolio_values = ending_portfolio_values
    end

    def count
      @ending_portfolio_values.count
    end

    def mean
      @ending_portfolio_values.mean
    end

    def num_zeros
      count = 0
      @ending_portfolio_values.each do |value|
        count += 1 if value == 0
      end
      count
    end

    def likelihood_of_running_out_of_money
      1.0 * num_zeros / count
    end
  end
end
