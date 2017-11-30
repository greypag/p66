class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_action :db,:now

  require 'mailgun'
  require 'securerandom'

  def db
      config = YAML::load_file("config/database.yml")["development"]
      config["host"] = config["hostname"]

      @db = Mysql2::Client.new(config)

      # @db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "pass", :database => "Parrot66_development")
  end


  def postresetpassword
      token = params[:token]
      password = params[:password]


      if token == nil || password == nil
          data = {:message => "missing input", :status => "false"}
          return render :json => data, :status => :ok
      end

      @exist_users = User.find_by_token(token)
      session[:f_name] = @exist_users.f_name

      if @exist_users == nil
          data = {:message => "no exist user", :status => "false"}
          return render :json => data, :status => :ok
      end

      @current_user_password = @exist_users["password"]
      @encrypted_password = BCrypt::Password.new(@current_user_password)
      @auth = (@encrypted_password == password)

      if @auth == true
          data = {:message => "cant use the same password", :status => "false"}
          return render :json => data, :status => :ok
      end

      password = BCrypt::Password.create(password)
      new_token = SecureRandom.uuid + "-" + rand(1000).to_s + "-" + SecureRandom.uuid

      @exist_users.update_attributes(:password => password, :token => new_token)

      data = {:message => "done", :status => "true"}
      return redirect_to "/resetpasswordsuccessful"
      return render :json => data, :status => :ok
  end

  def resetpasswordsuccessful
    @f_name = session[:f_name]
  end


  def getresetpassword
      token = params[:token]

      if token == nil
          return redirect_to "/"
      end

      @exist_users = User.find_by_token(token)

      if @exist_users == nil
          return redirect_to "/"
      end

      @token = token

      # data = {:message => "getresetpassword", :exist_users => @exist_users, :status => "true"}
      # return render :json => data, :status => :ok
  end




  def forget_email
      f_name = params[:f_name]
      l_name = params[:l_name]

      date_of_birth = params[:date_of_birth]

      return_mail = ""

      if f_name != nil && l_name != nil && date_of_birth != nil

        exist_users = User.where('f_name = ? and l_name = ? and date_of_birth = ?', f_name, l_name, date_of_birth)

        # data = {:message => exist_users,  :status => "true"}
        # return render :json => data, :status => :ok

        if exist_users.count.to_i != 0

            exist_users.each do |exist_user|
                # email = exist_users_d["email"]
                # token = exist_users_d["token"]
                # return_mail = exist_users_d["email"]

                mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
                mb_obj = Mailgun::MessageBuilder.new()
                mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});

                mb_obj.add_recipient(:to, exist_user.email, {"first" => f_name, "last" => l_name});
                mb_obj.set_subject("P66 | Forgot Email");

                result_msg = "<p>Dear "+f_name+" "+l_name+"</p>"
                result_msg += "<p>Thank you for using Parrot! Your email address is: "+exist_user.email+" <br />"
                result_msg += "<p></p>"
                result_msg += "<p>Kind regards,</p>"
                result_msg += "<p>Thank you for registering with Parrot!</p>"


                mb_obj.set_html_body(result_msg);
                mg_client.send_message("parrot66.com", mb_obj)
            end

            # data = {:message => "email sent", :email => exist_user.email,  :status => "true"}
            # return render :json => data, :status => :ok
        else

            data = {:message => "We can't find your user record, please make sure you input the correct data, if there's any issue please contact us.", :status => "false"}
            return render :json => data, :status => :ok
        end



      else

        data = {:message => "Please Input All Field", :status => "false"}
        return render :json => data, :status => :ok
      end
  end



  def forget_password

      email = params[:email]

      if email != nil

          exist_users = User.find_by_email(email)

          if exist_users != nil

              mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
              mb_obj = Mailgun::MessageBuilder.new()
              mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});

              email = exist_users["email"]
              token = exist_users["token"]
              f_name = exist_users["f_name"]
              l_name = exist_users["l_name"]

              mb_obj.add_recipient(:to, email, {"first" => f_name, "last" => l_name});
              mb_obj.set_subject("P66 | Forgot Password");

              result_msg = "<p>Dear "+f_name.to_s+" "+l_name.to_s+"</p>"
              result_msg += "<p>Thank you for using Parrot! To reset your password, please click on the link below:</p><br />"
              result_msg += "<a target='_blank' href='"+request.host+"/resetpassword?token="+token.to_s+"'>http://"+request.host+"/resetpassword?token="+token.to_s+"</a>"
              result_msg += "<p></p>"
              result_msg += "<p>This link will expires after 24 hours</p>"
              result_msg += "<p></p>"
              result_msg += "<p>Kind regards,</p>"
              result_msg += "<p>Thank you for registering with Parrot!</p>"


              mb_obj.set_html_body(result_msg);
              mg_client.send_message("parrot66.com", mb_obj)

              data = {:message => "email sent", :status => "true"}
              return render :json => data, :status => :ok
          else

              data = {:message => "We can't find your user record, please make sure you input the correct data, if there's any issue please contact us.", :status => "false"}
              return render :json => data, :status => :ok
          end

      else

          data = {:message => "Please Input All Field", :status => "false"}
          return render :json => data, :status => :ok
      end
  end

  def resendtoken
      token = session[:active_link_new_token]
      email = session[:sign_up_email]

      f_name = session[:f_name]
      l_name = session[:l_name]


      if token != nil && email != nil

        mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
        mb_obj = Mailgun::MessageBuilder.new()
        # @user.email.to_s
        mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
        mb_obj.add_recipient(:to, email, {"first" => f_name.to_s, "last" => l_name.to_s});

        mb_obj.set_subject("P66 | Account Re-active email");
        # mb_obj.set_text_body(result_msg);

        result_msg = "<p>Dear "+f_name.to_s+" "+l_name.to_s+"</p>"
        result_msg += "<p>Thank you for registering at Parrot! To activate your account, please click on the link below:<br />"
        result_msg += "<a target='_blank' href='"+request.host+"/activeuser?token="+token.to_s+"'>Click Here</a></p>"
        result_msg += "<p></p>"
        result_msg += "<p>This link will expires after 24 hours</p>"
        result_msg += "<p></p>"
        result_msg += "<p>Kind regards,</p>"
        result_msg += "<p>Thank you for registering with Parrot!</p>"


        mb_obj.set_html_body(result_msg);
        mg_client.send_message("parrot66.com", mb_obj)
        # this part is the 3rd party mail function, need to setup when we get momre info from the domain


        session[:active_link_new_token] = nil

        data = {:message => "email sent", :status => "true"}
        return render :json => data, :status => :ok

      else

        data = {:message => email, :status => "false"}
        return render :json => data, :status => :ok
      end



  end



  def activeuser

      token = params[:token]

      if token.to_s == ""
          return redirect_to "/"
      end

      @exist_user = User.find_by_token(token)

      if @exist_user == nil
          return redirect_to "/"
      end

      create_time = @exist_user.updated_at.in_time_zone('Beijing').strftime("%Y-%m-%d %H:%M:%S %Z")
      minute_limit = 60*24
      # minute_limit = 1
      second_limit = minute_limit * 60

      second_between = ((@now.to_time - create_time.to_time)).to_i

      new_token = SecureRandom.uuid + "-" + rand(1000).to_s + "-" + SecureRandom.uuid

      if second_between > second_limit

          session[:active_link_new_token] = new_token
          session[:sign_up_email] = @exist_user["email"]
          session[:f_name] = @exist_user["f_name"]
          session[:l_name] = @exist_user["l_name"]

          @db.query("UPDATE users SET updated_at=now(), token='"+new_token.to_s+"' WHERE token='"+token.to_s+"'")

          return redirect_to "/active_link_fail"
      else

          @db.query("UPDATE users SET status=1, updated_at=now(), token='"+new_token.to_s+"' WHERE token='"+token.to_s+"'")
          return redirect_to "/active_link_done"
      end

  end


  def authuser

      if session[:user_id].nil?
        return redirect_to "/"
      end

      # @current_user = @db.query("SELECT * FROM users WHERE id = "+session[:user_id].to_s)
      @current_user = User.find_by_id(session[:user_id])

      if @current_user.nil?
        session[:user_id] = nil
        return redirect_to "/"
      end


      if session[:expires_at].to_time < Time.current
        session[:user_id] = nil
        session[:status] = nil
        return redirect_to "/"
      else
        session[:expires_at] = Time.current + 1.hours
      end

  end

  def anti_authuser
    if !session[:user_id].nil?
      return redirect_to "/home"
    end
  end


  def now
      @now = Time.now.in_time_zone('Beijing').strftime("%Y-%m-%d %H:%M:%S %Z")
      @today = Date.today.in_time_zone('Beijing')
  end

  # shopping cart

  # helper_method :current_cart
  #
  # def current_cart
  #   @current_cart ||= find_cart
  # end

  private

  # def find_cart
  #   cart = Cart.find_by(id: session[:cart_id])
  #
  #   unless cart.present?
  #     cart = Cart.create
  #   end
  #
  #   session[:cart_id] = cart.id
  #   cart
  # end

end
