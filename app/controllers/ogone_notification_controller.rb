class OgoneNotificationController < ApplicationController
  class OgoneFailed < StandardError; end
  
  include ActiveMerchant::Billing::Integrations

  def show
    create
  end

  def create
    integration = Billing::Ogone.current
    
    notification = Ogone::Notification.new(request.query_string)
    order_number = notification.order_id.match(/^(R\d+)\/\d+$/)[1]
    @order = Order.find_by_number!(order_number)
    
    raise OgoneFailed unless notification.complete?
    
    unless @order.checkout_complete
      @order.checkout.next!
    
      payment = Payment.new(:amount => notification.gross)
      payment.payable = @order.reload
      payment.payment_method = PaymentMethod.find_by_type_and_active_and_environment("Billing::Ogone", true, Rails.env)
      payment.save!
    end
    
    session[:order_id] = nil
    flash[:commerce_tracking] = I18n.t("notice_messages.track_me_in_GA")
    flash[:notice] = I18n.t('order_processed_successfully')

    redirect_to @order, {:checkout_complete => true, :order_token => @order.token}
  rescue OgoneFailed
    session[:order_id] = nil
    flash[:error] = I18n.t('unable_to_authorize_credit_card')
    redirect_to root_path
  end
end
