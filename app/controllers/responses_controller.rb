class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy]
  before_action :authuser

  # GET /responses
  # GET /responses.json
  def index
    if !@current_user.admin?
      redirect_to '/home'
    end

    @responses = Response.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
    @response = Response.find(params[:id])
  end

  # GET /responses/new
  def new
    if !@current_user.admin?
      redirect_to '/home'
    end

    @response = Response.new
  end

  # GET /responses/1/edit
  def edit
    @response = Response.find(params[:id])
  end


  # POST /responses
  # POST /responses.json
  def create
    @response = Response.new(response_params)

    @response.user_id = @current_user.id

    if @response.title.to_s == "" || @response.language.to_s == "" || @response.industry.to_s == "" || @response.level.to_s == "" || @response.avatar.to_s == "" || @response.response_type.to_s == ""
        return redirect_to new_response_path, notice: "Please fill in all required fields"
    end

    # data = {:message => @response, :status => "false"}
    #  return render :json => data, :status => :ok

    respond_to do |format|
      if @response.save
        format.html { redirect_to responses_path, notice: 'Response was successfully created.' }
        format.json { render :show, status: :created, location: @response }
      else
        #   data = {:message => @response.errors, :status => "false"}
        #  return render :json => data, :status => :ok
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  def audio_record_create
    @response = Response.new

    @response.user_id = @current_user.id

    @response.avatar = params[:avatar]
    @response.title = params[:title]
    @response.language = params[:language]
    @response.industry = params[:industry]
    @response.level = params[:level]
    @response.response_type = params[:type]

    if @response.title.to_s == "" || @response.language.to_s == "" || @response.industry.to_s == "" || @response.level.to_s == "" || @response.avatar.to_s == "" || @response.response_type.to_s == ""
        return redirect_to new_response_path, notice: "Please fill in all required fields"
    end

    # data = {:message => @response, :status => "false"}
    #  return render :json => data, :status => :ok

    respond_to do |format|
      if @response.save
        format.html { redirect_to responses_path, notice: 'Response was successfully created.' }
        format.json { render :show, status: :created, location: @response }
      else
        #   data = {:message => @response.errors, :status => "false"}
        #  return render :json => data, :status => :ok
        format.html { render :new }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    @response = Response.find(params[:id])
    respond_to do |format|
      if @response.update(response_params)
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { render :show, status: :ok, location: @response }
      else
        format.html { render :edit }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_response_type
    @response_type = params[:response_type]
    @response = Response.find_by_id(params[:response_id])

    @response.update_attribute(:response_type, @response_type)
      data = {:message => @response, :status => "false"}
      return render :json => data, :status => :ok
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html { redirect_to responses_url, notice: 'Response was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # rating the test
  def rater_available

    if !@current_user.rater? && !@current_user.admin?
      redirect_to "/home"
    end

    # @wait_for_verify = TestRecord.where(:photo_verification => 0, :status => 1)
    @complete_tests = TestRecord.where(:status => 1).group_by(&:photo_verification)

    @wait_for_verify_tests = @complete_tests[0]
    @verify_passed_tests = @complete_tests[1]

    # data = {:message => @verify_passed_tests, :status => "false"}
    # return render :json => data, :status => :ok

    @available_responses = []
    @english_responses = []
    @spanish_responses = []

    if !@verify_passed_tests.nil?

      @verify_passed_tests.each do |verify_passed_test|

        # data = {:message => @verify_passed_test, :status => "false"}
        # return render :json => data, :status => :ok

        response = Response.where(:status => 0, :test_record_id => verify_passed_test.id).order("test_record_id asc, level desc").first

        if !response.raters.include?(@current_user.id.to_s)
          if response.language == "English"
            @english_responses << response
          else
            @spanish_responses << response
          end
          # @available_responses << response
        end
      end

    end


    # data = {:message => @spanish_responses, :status => "false"}
    #  return render :json => data, :status => :ok

    #  @available_responses = {}
    #  @final_available_responses = {}
     #
    #  if @complete_tests.count.to_i > 0
    #    @complete_tests.each do |complete_test|
     #
    #    end
    #  end


    #  if @responses.count.to_i > 0
    #      @responses.each do |response|
    #          if @available_responses["test"+response.test_record_id.to_s].nil?
    #              @available_responses["test"+response.test_record_id.to_s] = []
    #          end
     #
    #          @available_responses["test"+response.test_record_id.to_s] << response
    #      end
     #
    #      @final_available_responses = @available_responses
     #
    #      if !@available_responses.nil?
    #          @available_responses.each do |key,  val|
    #              if val.count.to_i > 0
    #                  val.each_with_index do |val_d, index|

                         # tmp_skip = 0
 #
                         # tmp_worst = val_d.worse_than
                         # tmp_as_good_as = val_d.as_good_as
                         # tmp_better_than = val_d.better_than


    #                  end
    #              end
    #          end
    #      end
     #
    #  end

    #  data = {:message => @available_responses, :status => "false"}
    #  return render :json => data, :status => :ok

  end

  def rate_response

    if !@current_user.rater? && !@current_user.admin?
      redirect_to "/home"
    end

    @response = Response.find(params[:id])

    if @response.raters.include?(@current_user.id.to_s)
      redirect_to "/rater_available"
    end

    @response.lock!


    @prompt = Prompt.find_by_id(@response.prompt_id)
    @bmr = Response.find_by_id(@prompt.bmr)

  end

  def give_a_rate
    @response = Response.find_by_id(params[:response_id])

    @rater_id = @current_user.id
    @rating = params[:rating]

    # data = {:hash => @rating, :status => "false"}
    # return render :json => data, :status => :ok


    if @rating == ""
        return redirect_to 'rate_response', notice: "Please send a score"
    end

    case @rating
    when "better than"
      @better_than = @response.better_than.split(",").map(&:to_i)
      @better_than << @rater_id
      @better_than = @better_than.join(",")

      @raters = @response.raters.split(",").map(&:to_i)
      @raters << @rater_id
      @raters = @raters.join(",")

      @response.update_attributes(:better_than => @better_than, :raters => @raters)
      if @response.better_than.split(",").count == 3
        @response.update_attributes(:score => "better than", :status => 1 )

        # determine final score of the test record
        @other_response = Response.where(:test_record_id => @response.test_record_id, :level => @response.level).where.not(:order => @response.order)
        if !@other_response[0].score.blank? && @other_response[0].score != "worse than"
          @test_record = TestRecord.find_by_id(@response.test_record_id)
          @test_record.update_attributes(:score => @response.level)

          # become a rater
          if @test_record.score == 5
            @user = User.find_by_id(@test_record.user_id)
            @user.update_attributes(:is_rater => 1)
          end
        end
      end
    when "as good as"
      @as_good_as = @response.as_good_as.split(",").map(&:to_i)
      @as_good_as << @rater_id
      @as_good_as = @as_good_as.join(",")

      @raters = @response.raters.split(",").map(&:to_i)
      @raters << @rater_id
      @raters = @raters.join(",")

      @response.update_attributes(:as_good_as => @as_good_as, :raters => @raters)
      if @response.as_good_as.split(",").count == 3
        @response.update_attributes(:score => "as good as", :status => 1 )

        # determine final score of the test record
        @other_response = Response.where(:test_record_id => @response.test_record_id, :level => @response.level).where.not(:order => @response.order)
        if !@other_response[0].score.blank? && @other_response[0].score != "worse than"
          @test_record = TestRecord.find_by_id(@response.test_record_id)
          @test_record.update_attributes(:score => @response.level)

          # become a rater
          if @test_record.score == 5
            @user = User.find_by_id(@test_record.user_id)
            @user.update_attributes(:is_rater => 1)
          end
        end
      end
    when "worse than"
      @worse_than = @response.worse_than.split(",").map(&:to_i)
      @worse_than << @rater_id
      @worse_than = @worse_than.join(",")

      @raters = @response.raters.split(",").map(&:to_i)
      @raters << @rater_id
      @raters = @raters.join(",")

      @response.update_attributes(:worse_than => @worse_than, :raters => @raters)
      if @response.worse_than.split(",").count == 3
        @response.update_attributes(:score => "worse than", :status => 1 )
          if @response.order == 1
            @second_response = Response.where(:test_record_id =>  @response.test_record_id, :level => @response.level, :order => 2)
            @second_response.update(:status => 1)
          end
      end
    end

    if @response.level == 1 && @response.score == "worse than"
      @test_record = TestRecord.find_by_id(@response.test_record_id)
      @test_record.update_attributes(:score => "Failed")
    end

    redirect_to '/rater_available', notice: "Rating Success!"

    #  data = {:hash => @test_record, :status => "false"}
    #  return render :json => data, :status => :ok

  end

  # candidate response
  def test_answer
    @response = Response.new

    @response.avatar = params[:avatar]
    @response.title = params[:title]
    @response.language = params[:language]
    @response.industry = params[:industry]
    @response.level = params[:level]
    @response.response_type = 0
    @response.user_id = @current_user.id
    @response.test_record_id = params[:test_record_id]
    @response.prompt_id = params[:prompt_id]
    @response.order = params[:order]
    @response.status = 1

     # data = {:message => @response, :status => "false"}
     # return render :json => data, :status => :ok

     @response.save

     if @response.level == 5 && @response.order == 2
       redirect_to "/test_end_camera"
     end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_params
      params.fetch(:response, {})

      params.require(:response).permit(:title, :language, :industry, :level, :avatar, :avatar_cache, :response_type)
    end
end
