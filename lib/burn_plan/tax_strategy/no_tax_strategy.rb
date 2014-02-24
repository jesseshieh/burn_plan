module BurnPlan
  module TaxStrategy
    class NoTaxStrategy < TaxStrategy
      def initialize

      end

      def pretax_distribution_amount(asset, after_tax_amount)
        after_tax_amount
      end
    end
  end
end
