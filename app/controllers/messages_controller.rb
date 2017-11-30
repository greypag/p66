class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :authuser

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    @inbox_messages = Message.where(:to_user_id => @current_user.id.to_s).or(Message.where(:is_system_notification => 1)).order("created_at DESC")
    @sendbox_messages = Message.where(:user_id => @current_user.id.to_s).order("created_at DESC")
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = @message
    @parent = Message.find_by_id(@reply_message_id)

    if @message.is_system_notification != 1
      @id = []
      @id << @message.user_id.to_s && @id << @message.to_user_id.to_s
      if !@id.include?(@current_user.id.to_s)
        redirect_to "/contact_us"
      end
    else
      @to_user_id_array = @message.to_user_id.split(",")
      if !@to_user_id_array.include?(@current_user.id.to_s)
        redirect_to "/contact_us"
      end
    end


  end

  # GET /messages/new
  def new
    @user = User.all
    @message = @current_user.messages.new
    @email_list = ["All"]
    @user.each do |u|
      @email_list << u.email
    end

    @reply_message_id = params[:reply_message_id]
    @reply_user_id = params[:reply_user_id]
    @reply_user_email = params[:reply_user_email]
    @reply_subject = params[:reply_subject]
    @reply_content = params[:reply_content]
    # data = {:message => @reply_user_email, :status => "false"}
    # return render :json => data, :status => :ok
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = @current_user.messages.new(message_params)
    @message.from_email = @current_user.email

    if @message.subject.to_s == "" && @message.content.to_s == ""
        return redirect_to "/new_message", alert: "You can not send an empty message."
    end

    if !@current_user.admin?
      @message.to_user_id = "1"
      @message.email = "admin@parrot66.com"

      respond_to do |format|
        if @message.save
          # @message.update_attribute(:parent_id, @message.id)
          format.html { redirect_to "/contact_us", notice: 'Your messages has been sent.' }
          # format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new }
          # format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    else
      @user = User.all
      @to_user_id_list = []
      @user.each do |u|
        @to_user_id_list << u.id.to_s
      end
      @to_user_id_list = @to_user_id_list.join(",")

      if @message.email == "All"
        @message.is_system_notification = 1
        @message.to_user_id = @to_user_id_list

        @user.each do |u|
          mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
          mb_obj = Mailgun::MessageBuilder.new()

          mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
          mb_obj.add_recipient(:to, u.email, {"first"=> u.f_name.to_s, "last" => u.l_name.to_s});
          mb_obj.set_subject("P66 | New message notification");

          result_msg = "<p>Dear "+u.f_name.to_s+" "+u.l_name.to_s+"</p>"
          result_msg += "<p>you have a new message from Parrot66<br />"
          result_msg += "please check your user account.</p>"
          result_msg += "<p></p>"
          result_msg += "<p>Best regards,</p>"

          mb_obj.set_html_body(result_msg);
          mg_client.send_message("parrot66.com", mb_obj)
        end

      else
        @receive_user = User.find_by_email(@message.email)
        @message.to_user_id = @receive_user.id.to_s

        mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
        mb_obj = Mailgun::MessageBuilder.new()

        mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
        mb_obj.add_recipient(:to, @receive_user.email, {"first"=> @receive_user.f_name.to_s, "last" => @receive_user.l_name.to_s});
        mb_obj.set_subject("P66 | New message notification");

        result_msg = "<p>Dear "+@receive_user.f_name.to_s+" "+@receive_user.l_name.to_s+"</p>"
        result_msg += "<p>you have a new message from Parrot66<br />"
        result_msg += "please check your user account.</p>"
        result_msg += "<p></p>"
        result_msg += "<p>Best regards,</p>"

        mb_obj.set_html_body(result_msg);
        mg_client.send_message("parrot66.com", mb_obj)
      end

      respond_to do |format|
        if @message.save
          # @message.update_attribute(:parent_id, @message.id)
          format.html { redirect_to "/contact_us", notice: 'Your messages has been sent.' }
          # format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new }
          # format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def reply
    @reply_message_id = params[:reply_message_id]
    @reply_user_id =  params[:reply_user_id]
    @reply_user_email = params[:reply_user_email]
    @reply_subject = params[:reply_subject]
    @reply_content = params[:reply_content]

    if @reply_content == ""
      return redirect_to :back, alert: "You can not send an empty message."
    end

    # @parent = Message.find_by_id(@reply_message_id)
    @message = @current_user.messages.new(:parent_id => @reply_message_id)

    @message.to_user_id = @reply_user_id
    @message.email = @reply_user_email
    @message.from_email = @current_user.email
    @message.subject = @reply_subject
    @message.content = @reply_content

    # data = {:message => Message.children, :status => "false"}
    # return render :json => data, :status => :ok

    if !@current_user.admin?
      @message.email = "admin@parrot66.com"
      respond_to do |format|
        if @message.save
          format.html { redirect_to "/contact_us", notice: 'Your messages has been sent.' }
          # format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new }
          # format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end

    # data = {:message => params[:reply_user_email], :status => "false"}
    # return render :json => data, :status => :ok

    # redirect_to new_message_path(reply_message_id: params[:reply_message_id], reply_user_id: params[:reply_user_id], reply_user_email: params[:reply_user_email], reply_subject: params[:reply_subject], reply_content: params[:reply_content])
    else
      @receive_user = User.find_by_email(@reply_user_email)
      mg_client = Mailgun::Client.new("key-e55d9349c3a7816034d2dab0ae5b8808")
      mb_obj = Mailgun::MessageBuilder.new()

      mb_obj.set_from_address("do-not-reply@parrot.com", {"first"=>"Parrot 66", "last" => ""});
      mb_obj.add_recipient(:to, @receive_user.email, {"first"=> @receive_user.f_name.to_s, "last" => @receive_user.l_name.to_s});
      mb_obj.set_subject("P66 | New message notification");

      result_msg = "<p>Dear "+@receive_user.f_name.to_s+" "+@receive_user.l_name.to_s+"</p>"
      result_msg += "<p>you have a new message from Parrot66<br />"
      result_msg += "please check your user account.</p>"
      result_msg += "<p></p>"
      result_msg += "<p>Best regards,</p>"

      mb_obj.set_html_body(result_msg);
      mg_client.send_message("parrot66.com", mb_obj)

      respond_to do |format|
        if @message.save
          format.html { redirect_to "/contact_us", notice: 'Your messages has been sent.' }
          # format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new }
          # format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        # format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        # format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete
    @box =  params[:box]
    @message_id = params[:message_id]
    @user_id = params[:user_id]
    @to_user_id = params[:to_user_id]

    @user = User.all
    @to_user_id_list = []
    @user.each do |u|
      @to_user_id_list << u.id.to_s
    end
    @to_user_id_list = @to_user_id_list.join(",")

    @delete_message = Message.where(:id => @message_id)
    if !@delete_message.empty?
      @delete_message.each do |d|
        if d.is_system_notification == 1
          if @box == "inbox"
            @delete_user_id_list = @to_user_id_list.split(",")
            @delete_user_id_list -= [@to_user_id]
            @delete_user_id_list = @delete_user_id_list.join(",")
            d.update_attribute(:to_user_id, @delete_user_id_list)
            # data = {:message => d, :status => "false"}
            # return render :json => data, :status => :ok
          elsif @box == "sendbox"
            d.update_attribute(:user_id, "")
          end
          # if @delete_user_id_list == []
          #   d.destroy
          # end
        else
          if @box == "inbox"
            d.update_attribute(:to_user_id, "")
          elsif @box == "sendbox"
            d.update_attribute(:user_id, "")
          end

          # if d.to_user_id == "" || d.user_id == ""
          #   d.destroy
          # end
        end
        # data = {:message => d, :status => "false"}
        # return render :json => data, :status => :ok
      end
    end
    # data = {:message => @delete_message, :status => "false"}
    # return render :json => data, :status => :ok
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'The conversation has been deleted.' }
      format.json { head :no_content }
    end
  end

  def inbox_reload
    @inbox_messages = Message.where(:to_user_id => @current_user.id.to_s).or(Message.where(:is_system_notification => 1)).order("created_at DESC")
    render :partial => 'inbox_message'
  end

  def sendbox_reload
    @sendbox_messages = Message.where(:user_id => @current_user.id.to_s).order("created_at DESC")
    render :partial => 'sendbox_message'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.fetch(:message, {})

      params.require(:message).permit(:subject, :content, :to_user_id, :email)
    end
end
