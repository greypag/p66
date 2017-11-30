class PayoutRecordsController < ApplicationController
  before_action :set_payout_record, only: [:show, :edit, :update, :destroy]
  before_action :authuser

  # GET /payout_records
  # GET /payout_records.json
  def index
    # @payout_records = PayoutRecord.all
    @users = User.where(:is_rater => 1).paginate(:page => params[:page], :per_page => 15)

  end

  # GET /payout_records/1
  # GET /payout_records/1.json
  def show
  end

  # GET /payout_records/new
  def new
    @payout_record = PayoutRecord.new
  end

  # GET /payout_records/1/edit
  def edit
  end

  # POST /payout_records
  # POST /payout_records.json
  def create
    @payout_record = PayoutRecord.new(payout_record_params)

    respond_to do |format|
      if @payout_record.save
        format.html { redirect_to @payout_record, notice: 'Payout record was successfully created.' }
        format.json { render :show, status: :created, location: @payout_record }
      else
        format.html { render :new }
        format.json { render json: @payout_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payout_records/1
  # PATCH/PUT /payout_records/1.json
  def update
    respond_to do |format|
      if @payout_record.update(payout_record_params)
        format.html { redirect_to @payout_record, notice: 'Payout record was successfully updated.' }
        format.json { render :show, status: :ok, location: @payout_record }
      else
        format.html { render :edit }
        format.json { render json: @payout_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payout_records/1
  # DELETE /payout_records/1.json
  def destroy
    @payout_record.destroy
    respond_to do |format|
      format.html { redirect_to payout_records_url, notice: 'Payout record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payout_record
      @payout_record = PayoutRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payout_record_params
      params.fetch(:payout_record, {})

      params.require(:payout_record).permit(:rater_id, :payout_status, :payout_id, :amount)
    end
end
