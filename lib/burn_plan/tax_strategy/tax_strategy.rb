module BurnPlan
  module TaxStrategy
    class TaxStrategy
      def initialize

      end

      def compute_tax(trades)
        raise NotImplementedError
      end
    end
  end
end
