module BurnPlan
  module TaxStrategy
    class NoTaxStrategy
      def initialize

      end

      def compute_tax(trades)
        0 # no taxes
      end
    end
  end
end
