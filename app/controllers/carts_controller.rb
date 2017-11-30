class CartsController < ApplicationController
  before_action :anti_authuser
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cart
    if session[:cart_expires_at].nil?
      session[:tests] = []
    elsif session[:cart_expires_at].to_time < Time.current
      session[:tests] = []
    end

    @cart_items = session[:tests]

    if !@cart_items.nil?
      # caculate price
      @sum = 0
      @cart_items.each do |cart_item|
        @test = Test.find_by_id(cart_item)

        @sum = @sum + @test.price.to_d
      end

      @sum = @sum.to_s
      session[:total_price] = @sum
    else
      @sum = "0.00"
    end

  end

  def clean_cart
    session[:tests] = nil
    $tests = []
    # data = {:message => session[:tests], :status => "true"}
    # return render :json => data, :status => :ok
    data = {:message => $tests, :status => "true"}
    respond_to do |format|
      format.html { redirect_to cart_path, alert: 'Cart has been cleared.' }
      format.json { render :json => data, :status => :ok }
    end
  end

  def delete_item
    @delete_item = params[:item].to_i
    # @test = Test.find_by_id(@delete_item)

    session[:tests].delete_at(@delete_item)
    $tests.delete_at(@delete_item)

    # data = {:message => session[:tests][@delete_item], :message2 => session[:tests], :status => "false"}
    # return render :json => data, :status => :ok

    data = {:message => session[:tests], :status => "true"}

    respond_to do |format|
      format.html { redirect_to cart_path, alert: ' the item has been deleted.' }
      format.json { render :json => data, :status => :ok }
    end
  end

  def cart_login
    @email =  params[:email]
    @password = params[:password]

    # data = {:message => @price, :status => "false"}
    # return render :json => data, :status => :ok

    @current_user = User.find_by_email(@email)

    if @current_user == nil
      data = {:message => "This user was not found in the system.", :status => "false"}
      return render :json => data, :status => :ok
    end

    @current_user_password = @current_user["password"]
    @id = @current_user["id"]

    @encrypted_password = BCrypt::Password.new(@current_user_password)
    @auth = (@encrypted_password == @password)

    if @auth != true
      data = {:message => "The password entered does not match the password for this account. Please try again.", :status => "false"}
      return render :json => data, :status => :ok
    end


    @current_user_confirm_id = @current_user["id"]
    @current_user_status = @current_user["status"]

    # if @current_user_status.to_s != "1"
      # data = {:message => "Your Account is Disable, Please contact your admin to enable it.", :status => "false"}
      # return render :json => data, :status => :ok
    # end

    session[:user_id] = @current_user_confirm_id
    session[:status] = @current_user_status
    session[:expires_at] = Time.current + 1.hours


    @db.query("UPDATE users SET updated_at=now() WHERE email='"+@email.to_s+"'")

    # return redirect_to checkout_path

    data = {:message => "Logged In", :user_id => @current_user_confirm_id, :status => "true"}
    # return render :json => data, :status => :ok

    respond_to do |format|
      format.html { redirect_to checkout_path }
      format.json { render json: data, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {})
    end
end
