class Cart < ApplicationRecord
  # has_many :cart_items, dependent: :destroy
  # has_many :items, through: :cart_items, source: :test

  # def add_test_to_cart(test)
  #   ci = cart_items.build
  #   ci.test_id = test
  #   ci.save
    # data = {:message => ci, :status => "false"}
    # return render :json => data, :status => :ok
  # end

  # def total_price
  #   sum = 0
  #   items.each do |item|
  #     sum = sum + item.price.to_d
  #   end
  #
  #   sum.to_s
  # end

  # def clean!
  #   cart_items.destroy_all
  # end
end
