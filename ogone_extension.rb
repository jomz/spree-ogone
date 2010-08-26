require 'active_merchant_ogone'

class OgoneExtension < Spree::Extension
  version "1.0"
  description "Provides Ogone payment gateway support."
  url "http://yourwebsite.com/ogone"

  def self.require_gems(config)
    # config.gem "active_merchant_ogone", :source => 'http://gemcutter.org'
  end
  
  def activate
    Billing::Ogone.register
    
    # Do what the ActiveMerchant init does but not as a gem.
    ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
    
    # Add your extension tab to the admin.
    # Requires that you have defined an admin controller:
    # app/controllers/admin/yourextension_controller
    # and that you mapped your admin in config/routes

    #Admin::BaseController.class_eval do
    #  before_filter :add_yourextension_tab
    #
    #  def add_yourextension_tab
    #    # add_extension_admin_tab takes an array containing the same arguments expected
    #    # by the tab helper method:
    #    #   [ :extension_name, { :label => "Your Extension", :route => "/some/non/standard/route" } ]
    #    add_extension_admin_tab [ :yourextension ]
    #  end
    #end

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
