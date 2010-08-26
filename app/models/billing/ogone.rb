class Billing::Ogone < BillingIntegration
  preference :use_test, :boolean, :default => true
  preference :inbound_signature, :string
  preference :outbound_signature, :string  
  preference :currency, :string, :default => "USD" 
  preference :account_name, :string
  
  def self.current
    return @current_billing if defined? @current_billing
    
    @current_billing = first(:conditions => {:type => self.to_s, :environment => RAILS_ENV, :active => true})
    @current_billing.initialize_integration
    @current_billing
  end
  
  def [](config_setting)
    self.send("preferred_#{config_setting}")
  rescue NoMethodError
    super
  end
  
  def initialize_integration
    ActiveMerchant::Billing::Integrations::Ogone.inbound_signature = preferred_inbound_signature
    ActiveMerchant::Billing::Integrations::Ogone.outbound_signature = preferred_outbound_signature
    ActiveMerchant::Billing::Base.integration_mode = preferred_use_test ? :test : :production
  end
end