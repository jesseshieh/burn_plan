module BurnPlan
  class Inflation
    def initialize(rate)
      @rate = rate
    end

    def real_return(norminal_return)
      (1 + norminal_return) / (1 + @rate) - 1
    end
  end
end
