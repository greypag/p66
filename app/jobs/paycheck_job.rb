class PaycheckJob < ActiveJob::Base

  require 'paypal-sdk-rest'
  require 'securerandom'
  # require './runner.rb'

  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging

    def perform

      @raters = User.where.not(weekly_rated: 0)

      # data = {:message => @raters, :status => "false"}
      # return puts :json => data, :status => :ok

      if @raters.nil?  # not execute if @raters == 0

        @items = []
        @commission = 9.99

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
        # return puts :json => data, :status => :ok

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


          x = 0
          @raters.each do |rater|

            # Get Payout Item Status
            @payout_item_detail= PayoutItem.get(@payout_batch.items[x].payout_item_id)
            logger.info "Got Payout Item Status[#{@payout_item_detail.payout_item_id}]"

            # data = {:message => @payout_item_detail.payout_item.amount.value, :status => "false"}
            # return puts :json => data, :status => :ok

            # create payout record
            @payout_record = PayoutRecord.new
            @payout_record[:rater_id] = rater.id
            @payout_record[:payout_status] = @payout_item_detail.transaction_status
            @payout_record[:payout_item_fee ] = @payout_item_detail.payout_item_fee.value
            @payout_record[:payout_id] = @payout_item_detail.payout_item_id
            @payout_record[:amount] = @payout_item_detail.payout_item.amount.value
            @payout_record.save

            # clear "weekly rated" and add "weekly rated" to "total rated"
            @quantity = rater.weekly_rated
            if !rater.total_rated.nil?
              @current_rated = rater.total_rated
              @new_total_rated = @quantity +  @current_rated
              rater.update_attributes(:weekly_rated => 0, :total_rated => @new_total_rated)
            else
              rater.update_attributes(:weekly_rated => 0, :total_rated => @quantity)
            end

            x += 1
          end

        rescue ResourceNotFound => err
          logger.error @payout.error.inspect
          # data = {:message => @payout.error.inspect, :status => "false"}
          # return puts :json => data, :status => :ok

        end

        # data = {:message => @payout_batch, :status => "false"}
        # return render :json => data, :status => :ok

      end



    end
end
