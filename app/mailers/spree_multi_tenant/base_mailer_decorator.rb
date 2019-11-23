module SpreeMultiTenant::BaseMailerDecorator
  if SpreeMultiTenant.configuration.use_tenanted_mailers
    def send_action(method_name, *args)
      tenant = Multitenant.current_tenant
      had_current_tenant = !tenant.nil?
      if !had_current_tenant && args.first # Attempt to get tenant from args.first
        if self.class == Spree::OrderMailer
          order = args.first.respond_to?(:id) ? args.first : Spree::Order.find(args.first)
          tenant = order.try(:tenant)
        elsif self.class == Spree::ReimbursementMailer
          reimbursement = args.first.respond_to?(:id) ? args.first : Spree::Reimbursement.find(args.first)
          tenant = reimbursement.try(:tenant)
        elsif self.class == Spree::ShipmentMailer
          shipment = args.first.respond_to?(:id) ? args.first : Spree::Shipment.find(args.first)
          tenant = shipment.try(:tenant)
        end
      end

      return super unless tenant

      # Add tenant views path
      path = "app/tenants/#{tenant.code}/views"
      prepend_view_path(path)

      if had_current_tenant
        super
      else
        # Execute ActiveRecord queries within the scope of the tenant
        SpreeMultiTenant.with_tenant tenant do
          super
        end
      end
    end
  end
end

mailer_classes = [
  Spree::BaseMailer,
]
mailer_classes.each do |mailer_class|
  mailer_class.include(SpreeMultiTenant::BaseMailerDecorator)
end
