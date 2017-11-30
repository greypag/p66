class PaypalsController < ApplicationController
  before_action :authuser

  require 'paypal-sdk-rest'
  require 'securerandom'
  # require './runner.rb'

  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging

  def index
    # ###Retrieve
    # Retrieve the PaymentHistory  by calling the
    # `all` method
    # on the Payment class
    # Refer the API documentation
    # for valid values for keys
    # Supported paramters are :count, :next_id
    @payment_history = Payment.all( :count => 10 )

    # List Payments
    logger.info "List Payment:"
    @payment_history.payments.each do |payment|
      logger.info "  -> Payment[#{payment.id}]"
    end
  end

  def new
    @payment = Payment.new
    @price = session[:total_price]
    @cart_items = session[:tests]
    # @cart_items = JSON[@cart_items]
    # @cart_items = @cart_items.map{|ci| ci.to_i}
    @card_type = ["visa", "mastercard", "discover", "amex"]
  end

  def checkout_with_credit_card

    @card_type = params[:card_type]
    @card_f_name =  params[:card_f_name]
    @card_l_name = params[:card_l_name]
    @card_number = params[:card_number]
    @card_cvv2 = params[:card_cvv2]
    @card_expire_month =  params[:card_expire_month]
    @card_expire_year = params[:card_expire_year]
    @card_address = params[:card_address]
    @card_city = params[:card_city]
    @card_country = params[:card_country]
    @card_state = params[:card_state]
    @card_postal_code = params[:card_postal_code]
    @total = session[:total_price]
    @purchased_items = session[:tests]

    if @card_type == "" || @card_f_name =="" || @card_l_name =="" || @card_number =="" || @card_cvv2 =="" || @card_expire_month =="" || @card_expire_year =="" || @card_address =="" || @card_city =="" || @card_country =="" || @card_state =="" || @card_postal_code ==""
      return redirect_to "/checkout", notice: "Please fill all the required field"
    end


    # Build Payment object
    @payment = Payment.new({
      :intent => "sale",
      :payer => {
        :payment_method => "credit_card",
        :funding_instruments => [{
          :credit_card => {
            :type => @card_type,
            :number => @card_number,
            :expire_month => @card_expire_month,
            :expire_year => @card_expire_year,
            :cvv2 => @card_cvv2,
            :first_name => @card_f_name,
            :last_name => @card_l_name,
            :billing_address => {
              :line1 => @card_address,
              :city => @card_city,
              :state => @card_state,
              :postal_code => @card_postal_code,
              :country_code => @card_country
            }
          }
        }]
      },
      :transactions => [{
        :amount => {
          :total => @total,
          :currency => "USD"
        },
        :description => "This is the payment transaction description."
      }]
    })

    # data = {:message => @payment, :status => "false"}
    # return render :json => data, :status => :ok

    # Create Payment and return the status(true or false)
    if @payment.create

      # data = {:message => @payment, :status => "false"}
      # return render :json => data, :status => :ok

      if @payment.payer.funding_instruments[0].nil?
        data = {:message => "funding_instruments is empty.", :status => "false"}
        return render :json => data, :status => :ok
      end

      session[:transaction_id] = @payment.id

      @purchased_items = @purchased_items.map{|ci| ci.to_i}

      @purchased_items.each do |purchased_item|
        @test = Test.find_by_id(purchased_item)

        # create payment record
        @payment_record = PaymentRecord.new
        @payment_record[:payment_id] = @payment.id
        @payment_record[:payment_method] = @payment.payer.payment_method
        @payment_record[:first_name] = @payment.payer.funding_instruments[0].credit_card.first_name
        @payment_record[:last_name] = @payment.payer.funding_instruments[0].credit_card.last_name
        @payment_record[:test_id] = @test.id
        @payment_record[:test_name] = @test.title
        @payment_record[:price] = @test.price
        @payment_record[:payment_status] = @payment.state
        @payment_record[:payment_time] = @payment.create_time
        @payment_record[:user_id] = @current_user.id

        @payment_record.save

        # creste test record
        @test_record = TestRecord.new
        @test_record[:user_id] = @current_user.id
        @test_record[:test_id] = @test.id
        @test_record[:test_name] = @test.title
        @test_record[:language] = @test.language
        @test_record[:industry] = @test.industry
        @test_record[:purchased_date] = @payment.create_time

        @test_record.save
      end

      # Thank you purchase email
      mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
      mb_obj = Mailgun::MessageBuilder.new()

      mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
      mb_obj.add_recipient(:to, @current_user.email, {"first"=> @current_user.f_name.to_s, "last" => @current_user.l_name.to_s});
      mb_obj.set_subject("P66 | Thanks for your Purchase");

      result_msg = "<h1>Thank you!</h1>"
      result_msg += "<p>Dear "+@current_user.f_name.to_s+" "+@current_user.l_name.to_s+"</p>"
      result_msg += "<p>All went well, and your test is ready when you are!<br />"
      result_msg += "For your reference, your transaction ID is</p>"+@payment.id
      result_msg += "<p></p>"
      result_msg += "<p>Best regards,</p>"

      mb_obj.set_html_body(result_msg);
      mg_client.send_message("parrot66.com", mb_obj)

      # current_cart.clean!
      session[:tests] = nil
      $tests = []
      redirect_to "/thankyoupurchase"

    else
      # Display Error message
      # data = {:message => @payment.error, :status => "false"}
      # return render :json => data, :status => :ok
      logger.error "Error while creating payment:"
      logger.error @payment.error.inspect
      redirect_to "/checkout", notice: "Payment failed"
    end
  end

  def checkout_with_paypal
    @payment_id = params[:paymentID]
    @purchased_items = session[:tests]
    session[:transaction_id] = @payment_id

    begin
      # Retrieve the payment object by calling the
      # `find` method
      # on the Payment class by passing Payment ID
      @payment = Payment.find(@payment_id)
      logger.info "Got Payment Details for Payment[#{@payment.id}]"

    rescue ResourceNotFound => err
      # It will throw ResourceNotFound exception if the payment not found
      logger.error "Payment Not Found"
    end
    # data = {:message => @payment, :status => "false"}
    # return render :json => data, :status => :ok

    @purchased_items = @purchased_items.map{|ci| ci.to_i}

    @purchased_items.each do |purchased_item|
      @test = Test.find_by_id(purchased_item)

      # create payment record
      @payment_record = PaymentRecord.new
      @payment_record[:payment_id] = @payment.id
      @payment_record[:payment_method] = @payment.payer.payment_method
      @payment_record[:first_name] = @current_user.f_name
      @payment_record[:last_name] = @current_user.l_name
      @payment_record[:test_id] = @test.id
      @payment_record[:test_name] = @test.title
      @payment_record[:price] = @test.price
      @payment_record[:payment_status] = @payment.state
      @payment_record[:payment_time] = @payment.create_time
      @payment_record[:user_id] = @current_user.id

      @payment_record.save

      # creste test record
      @test_record = TestRecord.new
      @test_record[:user_id] = @current_user.id
      @test_record[:test_id] = @test.id
      @test_record[:test_name] = @test.title
      @test_record[:language] = @test.language
      @test_record[:industry] = @test.industry
      @test_record[:purchased_date] = @payment.create_time

      @test_record.save
    end

    # Thank you purchase email
    mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
    mb_obj = Mailgun::MessageBuilder.new()

    mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
    mb_obj.add_recipient(:to, @current_user.email, {"first"=> @current_user.f_name.to_s, "last" => @current_user.l_name.to_s});
    mb_obj.set_subject("P66 | Thanks for your Purchase");

    result_msg = "<h1>Thank you!</h1>"
    result_msg += "<p>Dear "+@current_user.f_name.to_s+" "+@current_user.l_name.to_s+"</p>"
    result_msg += "<p>All went well, and your test is ready when you are!<br />"
    result_msg += "For your reference, your transaction ID is</p>"+@payment.id
    result_msg += "<p></p>"
    result_msg += "<p>Best regards,</p>"

    mb_obj.set_html_body(result_msg);
    mg_client.send_message("parrot66.com", mb_obj)

    # current_cart.clean!
    session[:tests] = nil
    $tests = []
    redirect_to "/thankyoupurchase"

  end

  def cancel_order
    # current_cart.clean!
    session[:tests] = nil
    $tests = []
    flash[:alert] = "Order has been canceled"
    redirect_to "/home"
  end

  def thankyoupurchase
    @transaction_id = session[:transaction_id]
  end

  def payout_create

    @raters = User.where.not(weekly_rated: 0)
    @items = []
    @commission = 9.99

    data = {:message => @raters.nil?, :status => "false"}
    return render :json => data, :status => :ok

    i = 1
    @raters.each do |rater|

      @value = @commission *  rater.weekly_rated.to_f

      @receiver = {
        "recipient_type": rater.recipient_type,
        "amount": {
        "value": @value.to_s,
        "currency": "USD"
        },
        "note": "Thanks for your patronage!",
        "sender_item_id":  Time.now.strftime("%Y%m%d") + i.to_s,
        "receiver": rater.receiver
      }
      @items << @receiver
      i += 1
    end

    # @items = [
    #   {
    #     "recipient_type": "EMAIL",
    #     "amount": {
    #     "value": "9.87",
    #     "currency": "USD"
    #     },
    #     "note": "Thanks for your patronage!",
    #     "sender_item_id": "201403140001",
    #     "receiver": "anybody01@gmail.com"
    #   },
    #   {
    #     "recipient_type": "PHONE",
    #     "amount": {
    #     "value": "112.34",
    #     "currency": "USD"
    #     },
    #     "note": "Thanks for your support!",
    #     "sender_item_id": "201403140002",
    #     "receiver": "91-734-234-1234"
    #   },
    #   {
    #     "recipient_type": "PHONE",
    #     "amount": {
    #     "value": "5.32",
    #     "currency": "USD"
    #     },
    #     "note": "Thanks for your patronage!",
    #     "sender_item_id": "201403140003",
    #     "receiver": "408-234-1234"
    #   },
    #   {
    #     "recipient_type": "PHONE",
    #     "amount": {
    #     "value": "5.32",
    #     "currency": "USD"
    #     },
    #     "note": "Thanks for your patronage!",
    #     "sender_item_id": "201403140004",
    #     "receiver": "408-234-1234"
    #   }
    # ]

    # data = {:message => @items, :status => "false"}
    # return render :json => data, :status => :ok

    @payout = Payout.new({
                         :sender_batch_header => {
                             :sender_batch_id => SecureRandom.hex(8),
                             :email_subject => 'You have a Payout!'
                         },
                         :items => @items
                     })
    begin
      @payout_batch = @payout.create
      logger.info "Created Payout with [#{@payout_batch.batch_header.payout_batch_id}]"

      # Get Payout Batch Status
      @payout_batch= Payout.get(@payout_batch.batch_header.payout_batch_id)
      logger.info "Got Payout Batch Status[#{@payout_batch.batch_header.payout_batch_id}]"

      # Get Payout Item Status
      @payout_item_details= PayoutItem.get(@payout_batch.items[0].payout_item_id)
      logger.info "Got Payout Item Status[#{@payout_item_details.payout_item_id}]"

      # clear "weekly rated" and add "weekly rated" to "total rated"
      # @raters.each do |rater|
      #   @quantity = rater.weekly_rated
      #   rater.update_attributes(:weekly_rated => 0, :total_rated => @quantity)
      # end

      # redirect_to '/raterpaycheck', notice: "Payout successful"

      data = {:message => @payout_item_details, :status => "false"}
      return render :json => data, :status => :ok
    rescue ResourceNotFound => err
      logger.error @payout.error.inspect
      data = {:message => @payout.error.inspect, :status => "false"}
      return render :json => data, :status => :ok

      # redirect_to '/raterpaycheck', notice: "Payout failed"
    end

    # data = {:message => @payout_batch, :status => "false"}
    # return render :json => data, :status => :ok

  end

end
