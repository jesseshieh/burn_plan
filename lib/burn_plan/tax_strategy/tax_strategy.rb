module BurnPlan
  module TaxStrategy
    class TaxStrategy
      def initialize

      end

      def pretax_distribution_amount(asset, after_tax_amount)
        raise NotImplementedError
      end
    end
  end
end
