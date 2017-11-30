class QarsController < ApplicationController
  before_action :set_qar, only: [:show, :edit, :update, :destroy]
  before_action :authuser

  # GET /qars
  # GET /qars.json
  def index
    @qars = Qar.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /qars/1
  # GET /qars/1.json
  def show
    @qar = Qar.find(params[:id])
  end

  # GET /qars/new
  def new
    if !@current_user.admin?
      redirect_to '/home'
    end

    @qar = Qar.new

    # prompt select
    @prompts = Prompt.all

    @all_prompt_hash = {}
    @all_lang_prompt_hash = {}
    @all_industry_prompt_hash = {}
    @all_level_prompt_hash = {}

    if @prompts.count.to_i > 0
        @prompts.each do |prompt|
            @all_prompt_hash[prompt["id"]] = prompt

            if @all_lang_prompt_hash[prompt["language"]].nil?
                @all_lang_prompt_hash[prompt["language"]] = []
            end

            if @all_industry_prompt_hash[prompt["industry"]].nil?
                @all_industry_prompt_hash[prompt["industry"]] = []
            end

            if @all_level_prompt_hash[prompt["level"]].nil?
                @all_level_prompt_hash[prompt["level"]] = []
            end

            @all_lang_prompt_hash[prompt["language"]] << prompt["id"]
            @all_industry_prompt_hash[prompt["industry"]] << prompt["id"]
            @all_level_prompt_hash[prompt["level"]] << prompt['id']
        end
    end


    # bmr select
    @bmrs = Response.where(:response_type => 1)

    @all_bmr_hash = {}
    @all_lang_bmr_hash = {}
    @all_industry_bmr_hash = {}
    @all_level_bmr_hash = {}

    if @bmrs.count.to_i > 0
        @bmrs.each do |bmr|
            @all_bmr_hash[bmr["id"]] = bmr

            if @all_lang_bmr_hash[bmr["language"]].nil?
                @all_lang_bmr_hash[bmr["language"]] = []
            end

            if @all_industry_bmr_hash[bmr["industry"]].nil?
                @all_industry_bmr_hash[bmr["industry"]] = []
            end


            if @all_level_bmr_hash[bmr["level"]].nil?
                @all_level_bmr_hash[bmr["level"]] = []
            end

            @all_lang_bmr_hash[bmr["language"]] << bmr["id"]
            @all_industry_bmr_hash[bmr["industry"]] << bmr["id"]
            @all_level_bmr_hash[bmr["level"]] << bmr["id"]
        end
    end


    # response select
    @responses = Response.where(:response_type => 0)

    @all_response_hash = {}
    @all_lang_response_hash = {}
    @all_industry_response_hash = {}
    @all_level_response_hash = {}

    if @responses.count.to_i > 0
        @responses.each do |response|
            @all_response_hash[response["id"]] = response

            if @all_lang_response_hash[response["language"]].nil?
                @all_lang_response_hash[response["language"]] = []
            end

            if @all_industry_response_hash[response["industry"]].nil?
                @all_industry_response_hash[response["industry"]] = []
            end


            if @all_level_response_hash[response["level"]].nil?
                @all_level_response_hash[response["level"]] = []
            end

            @all_lang_response_hash[response["language"]] << response["id"]
            @all_industry_response_hash[response["industry"]] << response["id"]
            @all_level_response_hash[response["level"]] << response["id"]
        end
    end

  end

  # GET /qars/1/edit
  def edit
    @qar = Qar.find(params[:id])
  end

  # POST /qars
  # POST /qars.json
  def create
    @qar = Qar.new(qar_params)

    respond_to do |format|
      if @qar.save
        format.html { redirect_to @qar, notice: 'Qar was successfully created.' }
        format.json { render :show, status: :created, location: @qar }
      else
        format.html { render :new }
        format.json { render json: @qar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /qars/1
  # PATCH/PUT /qars/1.json
  def update
    @qar = Qar.find(params[:id])

    respond_to do |format|
      if @qar.update(qar_params)
        format.html { redirect_to @qar, notice: 'Qar was successfully updated.' }
        format.json { render :show, status: :ok, location: @qar }
      else
        format.html { render :edit }
        format.json { render json: @qar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qars/1
  # DELETE /qars/1.json
  def destroy
    @qar.destroy
    respond_to do |format|
      format.html { redirect_to qars_url, notice: 'Qar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_qar
      @qar = Qar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def qar_params
      params.fetch(:qar, {})

      params.require(:qar).permit(:title, :language, :industry, :level, :prompt, :bmr, :response, :rating)
    end
end
