module BurnPlan
  module TaxStrategy
    class CapitalGainsTaxStrategy < TaxStrategy
      def initialize(tax_rate)
        raise ArgumentError.new("tax rate must be between [0, 1)") unless tax_rate >= 0 && tax_rate < 1
        @tax_rate = tax_rate
      end

      def pretax_distribution_amount(asset, after_tax_amount)
        # TODO: use real cost bases
        cost_basis = 0
        # tax_amount = (pretax_amount - cost_basis) * @tax_rate
        # after_tax_amount = pretax_amount - tax_amount
        (after_tax_amount - cost_basis * @tax_rate) / (1 - @tax_rate)
      end
    end
  end
end

