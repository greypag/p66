class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action :authuser, only: [:home, :edit, :update, :prompts, :sendscores, :dashboard]
  before_action :authuser, except: [:new, :create, :login, :logout]
  # GET /users
  # GET /users.json

  require 'date'


  def login

      @email =  params[:email]
      @password = params[:password]

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


      data = {:message => "Logged In", :user_id => @current_user_confirm_id, :status => "true"}

      if @current_user.is_admin?
        redirect_to "/dashboard"
      else
        redirect_to "/home"
      end

      # respond_to do |format|
        # format.html { redirect_to "/home" }
        # format.json { render :json => data, :status => :ok }
      # end
  end


  def logout

      session[:user_id] = nil
      session[:status] = nil

      return redirect_to "/"
  end

  def home
    @current_user = User.find(session[:user_id])
  end

  def dashboard
    if !@current_user.admin?
      redirect_to '/home'
    end

    # date
    @date_from  = Date.parse("2017-06-01").beginning_of_month
    @date_previous_month = Date.today.beginning_of_month - 1.month
    @date_to    = Date.today.beginning_of_month
    @date_range = @date_from..@date_to
    @month_range = @date_previous_month..@date_to

    @date_months = @date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
    @date_months = @date_months.map {|d| d.strftime "%Y-%-m" }
    # date_months = date_months.values_at(* date_months.each_index.select {|i| i.even?})


    # user data
    @users = User.group("year(created_at)", "month(created_at)").count
    @users_time = []
    @users_count = []
    @users.keys.each do |k|
      @users_time << k[0].to_s+ '-' + k[1].to_s
    end
    @users.values.each do |v|
      @users_count << v
    end
    @users_data = Hash[*@users_time.zip(@users_count).flatten]
    # @users_time.each_with_index { |@users_time, @users_count| @users_data[@users_time] = value[@users_count] }

    @users_hash = Hash[@date_months.map {|x| [x, 0]}]
    @users_hash = @users_hash.merge(@users_data){|key,val1,val2| val1 + val2}

    # new user count
    @new_users = User.where(:created_at => @month_range).count

    # rater count
    @raters = User.where(:is_rater => true).group("year(created_at)", "month(created_at)").count
    @raters_time = []
    @raters_count = []
    @raters.keys.each do |k|
      @raters_time << k[0].to_s+ '-' + k[1].to_s
    end
    @raters.values.each do |v|
      @raters_count << v
    end
    @raters_data = Hash[*@raters_time.zip(@raters_count).flatten]

    @raters_hash = Hash[@date_months.map {|x| [x, 0]}]
    @raters_hash = @raters_hash.merge(@raters_data){|key,val1,val2| val1 + val2}

    @total_raters = User.where(:is_rater => true).count


    # test data
    @ilr1_records = TestRecord.where(:score => 1).group("year(updated_at)", "month(updated_at)").count
    @ilr1_records_time = []
    @ilr1_records_count = []
    @ilr1_records.keys.each do |k|
      @ilr1_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @ilr1_records.values.each do |v|
      @ilr1_records_count << v
    end
    @ilr1_records_data = Hash[*@ilr1_records_time.zip(@ilr1_records_count).flatten]

    @ilr1_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @ilr1_records_hash = @ilr1_records_hash.merge(@ilr1_records_data){|key,val1,val2| val1 + val2}

    @ilr1plus_records = TestRecord.where(:score => 2).group("year(updated_at)", "month(updated_at)").count
    @ilr1plus_records_time = []
    @ilr1plus_records_count = []
    @ilr1plus_records.keys.each do |k|
      @ilr1plus_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @ilr1plus_records.values.each do |v|
      @ilr1plus_records_count << v
    end
    @ilr1plus_records_data = Hash[*@ilr1plus_records_time.zip(@ilr1plus_records_count).flatten]

    @ilr1plus_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @ilr1plus_records_hash = @ilr1plus_records_hash.merge(@ilr1plus_records_data){|key,val1,val2| val1 + val2}

    @ilr2_records = TestRecord.where(:score => 3).group("year(updated_at)", "month(updated_at)").count
    @ilr2_records_time = []
    @ilr2_records_count = []
    @ilr2_records.keys.each do |k|
      @ilr2_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @ilr2_records.values.each do |v|
      @ilr2_records_count << v
    end
    @ilr2_records_data = Hash[*@ilr2_records_time.zip(@ilr2_records_count).flatten]

    @ilr2_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @ilr2_records_hash = @ilr2_records_hash.merge(@ilr2_records_data){|key,val1,val2| val1 + val2}

    @ilr2plus_records = TestRecord.where(:score => 4).group("year(updated_at)", "month(updated_at)").count
    @ilr2plus_records_time = []
    @ilr2plus_records_count = []
    @ilr2plus_records.keys.each do |k|
      @ilr2plus_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @ilr2plus_records.values.each do |v|
      @ilr2plus_records_count << v
    end
    @ilr2plus_records_data = Hash[*@ilr2plus_records_time.zip(@ilr2plus_records_count).flatten]

    @ilr2plus_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @ilr2plus_records_hash = @ilr2plus_records_hash.merge(@ilr2plus_records_data){|key,val1,val2| val1 + val2}

    @ilr3_records = TestRecord.where(:score => 5).group("year(updated_at)", "month(updated_at)").count
    @ilr3_records_time = []
    @ilr3_records_count = []
    @ilr3_records.keys.each do |k|
      @ilr3_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @ilr3_records.values.each do |v|
      @ilr3_records_count << v
    end
    @ilr3_records_data = Hash[*@ilr3_records_time.zip(@ilr3_records_count).flatten]

    @ilr3_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @ilr3_records_hash = @ilr3_records_hash.merge(@ilr3_records_data){|key,val1,val2| val1 + val2}

    #  data = {:hash1 => @ilr1plus_records_hash, :status => "false"}
    #  return render :json => data, :status => :ok

    # payment data
    @payment_records = PaymentRecord.group("year(created_at)").group("month(created_at)").count
    @payment_records_time = []
    @payment_records_count = []
    @payment_records.keys.each do |k|
      @payment_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @payment_records.values.each do |v|
      @payment_records_count << v
    end
    @payment_records_data = Hash[*@payment_records_time.zip(@payment_records_count).flatten]

    @payment_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @payment_records_hash = @payment_records_hash.merge(@payment_records_data){|key,val1,val2| val1 + val2}

    # caculate revenue
    @revenue = PaymentRecord.all
    if !@revenue.nil?
      @sum = 0
      @revenue.each do |revenue|
        @sum = @sum + revenue.price.to_d
      end

      @sum = @sum.to_s
      @total_revenue = @sum
    else
      @sum = "0.00"
      @total_revenue = @sum
    end

    #  data = {:hash1 => @payment_records_hash, :status => "false"}
    #  return render :json => data, :status => :ok

    # rater paycheck
    @payout_records = PayoutRecord.group("year(created_at)").group("month(created_at)").count
    @payout_records_time = []
    @payout_records_count = []
    @payout_records.keys.each do |k|
      @payout_records_time << k[0].to_s+ '-' + k[1].to_s
    end
    @payout_records.values.each do |v|
      @payout_records_count << v
    end
    @payout_records_data = Hash[*@payout_records_time.zip(@payout_records_count).flatten]

    @payout_records_hash = Hash[@date_months.map {|x| [x, 0]}]
    @payout_records_hash = @payout_records_hash.merge(@payout_records_data){|key,val1,val2| val1 + val2}

    # caculate total paycheck
    @paycheck = PayoutRecord.all
    if !@paycheck.nil?
      @total = 0
      @paycheck.each do |paycheck|
        @total = @total + paycheck.amount.to_d
      end

      @total = @total.to_s
      @total_paycheck = @total
    else
      @total = "0.00"
      @total_paycheck = @total
    end

    # total balannce
    @total_balance = @sum.to_d - @total.to_d
    @total_balance = @total_balance.to_s

    #  data = {:hash1 => @payout_records_data, :status => "false"}
    #  return render :json => data, :status => :ok
  end

  def cashflow
    @payment_records = PaymentRecord.paginate(:page => params[:page], :per_page => 15)
  end

  def invite

  end

  def invite_user
    @email = params[:invite_email]
    @subject = params[:invite_subject]
    @message = params[:invite_content]

    if @email == "" || @subject == "" || @message == ""
      redirect_to "/invite", notice: "Please fill all require fields"
    end

    # this part is the 3rd party mail function, need to setup when we get momre info from the domain
    mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
    mb_obj = Mailgun::MessageBuilder.new()

    # @user.email.to_s
    mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
    mb_obj.add_recipient(:to, @email, @email);

    mb_obj.set_subject(@subject);
    # mb_obj.set_text_body(result_msg);

    result_msg = "<p>Dear "+@email+"</p>"
    result_msg += "<p>"+@message+"</p><br />"

    result_msg += "<p></p>"
    result_msg += "<p>Kind regards,</p>"


    mb_obj.set_html_body(result_msg);
    mg_client.send_message("parrot66.com", mb_obj)
    # this part is the 3rd party mail function, need to setup when we get momre info from the domain

    redirect_to users_path, notice: "The invitation has been sent."

  end


  def invite_as_rater
    @user = User.find_by_id(params[:user_id])

     # data = {:user => @user, :status => "false"}
     # return render :json => data, :status => :ok

    @user.update_attribute(:is_rater, 1)

    # this part is the 3rd party mail function, need to setup when we get momre info from the domain
    mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
    mb_obj = Mailgun::MessageBuilder.new()

    # @user.email.to_s
    mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
    mb_obj.add_recipient(:to, @user.email, {"first" => @user.f_name.to_s, "last" => @user.l_name.to_s});

    mb_obj.set_subject("P66 | Become a Rater");
    # mb_obj.set_text_body(result_msg);

    result_msg = "<p>Hi "+@user.f_name.to_s+" "+@user.l_name.to_s+"</p>"
    result_msg += "<p>Congratulations! You have met the requirement to join the exclusive family of Parrot Raters!</p><br />"
    result_msg += "<p>In under one minute you can now start earning money from your mobile phone, tablet or computer! The best part is you will be helping others get the Parrot credential they need to help support themselves and the language you share!</p><br />"
    result_msg += "<p>Your opportunity is now! Work whenever you want - just click on the link below to get started!</p><br />"
    result_msg += "<p></p><br />"
    result_msg += "<p>Best,</p><br />"
    result_msg += "<p>Parrot66</p>"



    mb_obj.set_html_body(result_msg);
    mg_client.send_message("parrot66.com", mb_obj)
    # this part is the 3rd party mail function, need to setup when we get momre info from the domain

  end


  def rating_history

  end

  def index
    if !@current_user.admin?
      redirect_to '/home'
    end
    @users = User.paginate(:page => params[:page], :per_page => 15)

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @current_user = User.find(session[:user_id])
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)

    if @user.f_name.to_s == "" || @user.email.to_s == "" || @user.email_confirmation.to_s == "" || @user.password.to_s == "" || @user.password_confirmation.to_s == "" || @user.native_language.to_s == "" || @user.date_of_birth.to_s == ""
        return redirect_to new_user_path, notice: "Please make sure you input all require field."
    end

    if @user.email.to_s != @user.email_confirmation.to_s
      return redirect_to new_user_path, notice: "Please make sure the email address is the same"
    end

    @email_password = @user.password.to_s

    if @user.password.to_s != @user.password_confirmation.to_s
        return redirect_to new_user_path, notice: "Please make sure the password is the same."
    end

    @exist_user = User.find_by_email(@user.email)

    if !@exist_user.nil?
        return redirect_to new_user_path, notice: "Sorry, User exist, please use any other email."
    end

    @rand_list = [('0'..'9'),('A'..'Z')].map(&:to_a).flatten
    @user.parrot_id = (1..6).map{ @rand_list[rand(@rand_list.length)] }.join

    @token = SecureRandom.uuid + "-" + rand(1000).to_s + "-" + SecureRandom.uuid

    @user.password = BCrypt::Password.create(@user.password)
    @user.token = @token.to_s
    @user.status = "0"

    # this part is the 3rd party mail function, need to setup when we get momre info from the domain
    mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
    mb_obj = Mailgun::MessageBuilder.new()

    # @user.email.to_s
    mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
    mb_obj.add_recipient(:to, @user.email, {"first" => @user.f_name.to_s, "last" => @user.l_name.to_s});

    mb_obj.set_subject("P66 | Auto welcome email");
    # mb_obj.set_text_body(result_msg);

    result_msg = "<p>Dear "+@user.f_name.to_s+" "+@user.l_name.to_s+"</p>"
    result_msg += "<p>Thank you for registering at Parrot! To activate your account, please click on the link below:</p><br />"
    result_msg += "<a href='"+request.host+"/activeuser?token="+@token.to_s+">http://"+request.host+"/activeuser?token="+@token.to_s+"</a>"
    result_msg += "<p></p>"
    result_msg += "<p>This link will expires after 24 hours.</p>"
    result_msg += "<p></p>"
    result_msg += "<p>Username : "+@user.email.to_s+"<br />"
    result_msg += "Password: "+@email_password.to_s+"</p>"
    result_msg += "<p></p>"
    result_msg += "<p>Kind regards,</p>"
    result_msg += "<p>Thank you for registering with Parrot!</p>"


    mb_obj.set_html_body(result_msg);
    mg_client.send_message("parrot66.com", mb_obj)
    # this part is the 3rd party mail function, need to setup when we get momre info from the domain

    session[:sign_up_email] = @user.email

    respond_to do |format|
      if @user.save
        # format.html { redirect_to thankyou_path, notice: 'User was successfully created.' }
        format.html { redirect_to thankyou_path, email: @user.email}
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to new_user_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end



  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @current_user = User.find(session[:user_id])

    if params[:user][:password] != params[:user][:password_confirmation]
      return redirect_to "/account", notice: "please make sure the password is the same"
    end

    @encrypted_password = BCrypt::Password.new(@current_user.password)
    @auth = (@encrypted_password == params[:user][:password])

    if @auth == true
      return redirect_to "/account", notice: "can not use the same password"
    end

    if params[:user][:password].to_s == "" || params[:user][:password_confirmation].to_s == ""
      params[:user][:password] = @current_user.password
    else
      params[:user][:password] = BCrypt::Password.create(params[:user][:password])
    end

    # @rand_list = [('0'..'9'),('A'..'Z')].map(&:to_a).flatten
    # params[:user][:parrot_id] = (1..6).map{ @rand_list[rand(@rand_list.length)] }.join

    # data = {:message => params[:user][:password], :status => "false"}
    # return render :json => data, :status => :ok

    respond_to do |format|
      if @user.update(user_params)
        # data = {:message => params[:user][:password], :status => "false"}
        # return render :json => data, :status => :ok
        format.html { redirect_to "/account", notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # def change_password
  #   @current_user = User.find(session[:user_id])
  #
  #   @password = params[:password]
  #   @password_confirmation = params[:password_confirmation]
  #
  #   if @password != @password_confirmation
  #     return redirect_to "/account", notice: "please make sure the password is the same"
  #   end
  #
  #   @encrypted_password = BCrypt::Password.new(@current_user.password)
  #   @auth = (@encrypted_password == @password)
  #
  #   if @auth == true
  #     return redirect_to "/account", notice: "can not use the same password"
  #   end
  #
  #   if @password.to_s == "" || @password_confirmation.to_s == ""
  #     @password = @current_user.password
  #   else
  #     @password = BCrypt::Password.create(@password)
  #   end
  #
  #   respond_to do |format|
  #     @current_user.update_attribute(:password, @password)
  #     format.html { redirect_to "/account", notice: 'Password changed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})

      params.require(:user).permit(:f_name, :email, :email_confirmation, :l_name, :native_language, :date_of_birth, :gender, :industry, :password, :password_confirmation, :avatar, :avatar_cache, :status, :token, :parrot_id, :recipient_type, :receiver)
    end
end
