class TestRecordsController < ApplicationController
  before_action :set_test_record, only: [:show, :edit, :update, :destroy]
  before_action :authuser


  # GET /test_records
  # GET /test_records.json
  def index
    @test_records = TestRecord.where(:user_id => @current_user.id).order(created_at: :desc)
    @test_record = @test_record
  end

  def score_histiry

  end

  # GET /test_records/1
  # GET /test_records/1.json
  def show
    @test_record = TestRecord.find(params[:id])
    @test = Test.find_by_id(@test_record.test_id)
    session[:test_record] = @test_record.id

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /test_records/new
  def new
    @test_record = TestRecord.new
  end

  # GET /test_records/1/edit
  def edit
  end

  # POST /test_records
  # POST /test_records.json
  def create
    @test_record = TestRecord.new(test_record_params)



    respond_to do |format|
      if @test_record.save
        format.html { redirect_to @test_record, notice: 'Test record was successfully created.' }
        format.json { render :show, status: :created, location: @test_record }
      else
        format.html { render :new }
        format.json { render json: @test_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_records/1
  # PATCH/PUT /test_records/1.json
  def update
    respond_to do |format|
      if @test_record.update(test_record_params)
        format.html { redirect_to @test_record, notice: 'Test record was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_record }
      else
        format.html { render :edit }
        format.json { render json: @test_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_records/1
  # DELETE /test_records/1.json
  def destroy
    @test_record.destroy
    respond_to do |format|
      format.html { redirect_to test_records_url, notice: 'Test record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def test_begin_camera
    @test_record = TestRecord.find_by_id(session[:test_record])
    @test = Test.find_by_id(@test_record.test_id)

    if @test_record.status == 1
      redirect_to test_records_path
    end

    @test_record.update_attribute(:start_date, DateTime.now)

  end

  def post_test_begin_photo
    @test_record = TestRecord.find_by_id(session[:test_record])
    @test = Test.find_by_id(@test_record.test_id)
    @test_begin_photo = params[:img]
    @test_record.update_attribute(:test_begin_photo, @test_begin_photo)

    # data = {:message => @test_record, :status => "false"}
    # render :json => data, :status => :ok

    redirect_to test_path(@test.id)
  end

  def test_end_camera
    @test_record = TestRecord.find_by_id(session[:test_record])
    @test = Test.find_by_id(@test_record.test_id)

  end

  def post_test_end_photo
    @test_record = TestRecord.find_by_id(session[:test_record])
    @test = Test.find_by_id(@test_record.test_id)
    @test_end_photo = params[:img]
    @test_record.update_attribute(:test_end_photo, @test_end_photo)

    # data = {:message => @test_record, :status => "false"}
    # render :json => data, :status => :ok

    redirect_to "/finished_test"
  end

  def photo_verification
    if !@current_user.rater? && !@current_user.admin?
      redirect_to "/home"
    end

    @test_record = TestRecord.find(params[:id])
  end

  def post_photo_verification
    @test_record = TestRecord.find_by_id(params[:test_record])
    @verify = params[:verify]

    # data = {:message => @test_record, :status => "false"}
    # render :json => data, :status => :ok

    @test_record.update_attribute(:photo_verification, @verify)

    redirect_to rater_available_path, notice: "The photos have been verified."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_record
      @test_record = TestRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_record_params
      params.fetch(:test_record, {})

      params.require(:test_record).permit(:user_id, :test_id, :status, :start_date, :finish_time, :score, :purchased_date, :test_begin_photo, :test_end_photo)
    end
end
