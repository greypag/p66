class PromptsController < ApplicationController
  before_action :set_prompt, only: [:show, :edit, :update, :destroy]
  before_action :authuser

  # GET /prompts
  # GET /prompts.json
  def index
    if !@current_user.admin?
      redirect_to '/home'
    end

    @prompts = Prompt.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /prompts/1
  # GET /prompts/1.json
  def show
    @prompt = Prompt.find(params[:id])
  end

  # GET /prompts/new
  def new
    if !@current_user.admin?
      redirect_to '/home'
    end
    #   data = {:message => params[:level], :status => "false"}
    #  return render :json => data, :status => :ok

    @prompt = Prompt.new
    @responses = Response.where(:response_type => 1)

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
      # data = {:message => @responses, :status => "false"}
      # return render :json => data, :status => :ok
  end


  # GET /prompts/1/edit
  def edit
    if !@current_user.admin?
      redirect_to '/home'
    end
    #   data = {:message => params[:level], :status => "false"}
    #  return render :json => data, :status => :ok

    @prompt = Prompt.find(params[:id])
    @responses = Response.where(:response_type => 1)

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

  # POST /prompts
  # POST /prompts.json
  def create
    @prompt = Prompt.new(prompt_params)

    if @prompt.title.to_s == "" || @prompt.language.to_s == "" || @prompt.industry.to_s == "" || @prompt.level.to_s == "" || @prompt.bmr.to_s == ""
      return redirect_to new_prompt_path, notice: "Please fill in all required fields"
    end
  #   data = {:message => @prompt, :status => "false"}
  #  return render :json => data, :status => :ok

    respond_to do |format|
      if @prompt.save
      #   data = {:message => @prompt, :status => "false"}
      #  return render :json => data, :status => :ok
        format.html { redirect_to prompts_path, notice: 'Prompt was successfully created.' }
        format.json { render :show, status: :created, location: @prompt }
      else
      #   data = {:message => @prompt.errors, :status => "false"}
      #  return render :json => data, :status => :ok
        format.html { render :new }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prompts/1
  # PATCH/PUT /prompts/1.json
  def update
    @prompt = Prompt.find(params[:id])

    respond_to do |format|
      if @prompt.update(prompt_params)
        format.html { redirect_to @prompt, notice: 'Prompt was successfully updated.' }
        format.json { render :show, status: :ok, location: @prompt }
      else
        #   data = {:message => @prompt.errors, :status => "false"}
        #  return render :json => data, :status => :ok
        format.html { render :edit }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prompts/1
  # DELETE /prompts/1.json
  def destroy
    @prompt.destroy
    respond_to do |format|
      format.html { redirect_to prompts_url, notice: 'Prompt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prompt
      @prompt = Prompt.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prompt_params
      params.fetch(:prompt, {})

      params.require(:prompt).permit(:title, :language, :industry, :level, :image, :video, :audio, :text, :bmr)
    end
end
