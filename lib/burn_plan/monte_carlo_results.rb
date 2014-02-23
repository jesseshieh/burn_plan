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
      @ending_portfolio_values = []
      @distribution_histories = []
    end

    def add_result(ending_portfolio_value, distribution_history)
      # TODO: consider creating a MonteCarloResult object
      @ending_portfolio_values << ending_portfolio_value
      @distribution_histories << distribution_history
      self
    end

    def build
      MonteCarloResults.new(@ending_portfolio_values, @distribution_histories)
    end
  end

  class MonteCarloResults
    def initialize(ending_portfolio_values, distribution_histories)
      @ending_portfolio_values = ending_portfolio_values
      @distribution_histories = distribution_histories
    end

    def ending_portfolio_values_count
      @ending_portfolio_values.count
    end

    def ending_portfolio_values_mean
      @ending_portfolio_values.mean
    end

    def ending_portfolio_values_num_zeros
      count = 0
      @ending_portfolio_values.each do |value|
        count += 1 if value == 0
      end
      count
    end

    def average_distribution
      n = 0
      mn = 0 # we do this rolling because otherwise the numbers may get too big
      @distribution_histories.each do |distribution_history|
        distribution_history.each do |distribution_amount|
          n += 1
          an = distribution_amount

          # http://math.stackexchange.com/questions/106700/incremental-averageing
          mn = mn + (an - mn) / n
        end
      end
      mn
    end

    def likelihood_of_running_out_of_money
      1.0 * ending_portfolio_values_num_zeros / ending_portfolio_values_count
    end
  end
end
