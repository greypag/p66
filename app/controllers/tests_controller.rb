class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]
  before_action :authuser, except: [:add_to_cart]


  # GET /tests
  # GET /tests.json
  def index
    if !@current_user.admin?
      redirect_to '/home'
    end

    @tests = Test.paginate(:page => params[:page], :per_page => 15)
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
    @test = Test.find(params[:id])
    @test_record = TestRecord.find_by_id(session[:test_record])

    # if @test_record.status == 1
    #   redirect_to test_records_path
    # end


    # @test_record.update_attribute(:start_date, DateTime.now)

    @ilr1_prompt1 = Prompt.find_by_id(@test.ilr1_prompt1.to_i)
    @ilr1_prompt2 = Prompt.find_by_id(@test.ilr1_prompt2.to_i)
    @ilr1plus_prompt1 = Prompt.find_by_id(@test.ilr1plus_prompt1.to_i)
    @ilr1plus_prompt2 = Prompt.find_by_id(@test.ilr1plus_prompt2.to_i)
    @ilr2_prompt1 = Prompt.find_by_id(@test.ilr2_prompt1.to_i)
    @ilr2_prompt2 = Prompt.find_by_id(@test.ilr2_prompt2.to_i)
    @ilr2plus_prompt1 = Prompt.find_by_id(@test.ilr2plus_prompt1.to_i)
    @ilr2plus_prompt2 = Prompt.find_by_id(@test.ilr2plus_prompt2.to_i)
    @ilr3_prompt1 = Prompt.find_by_id(@test.ilr3_prompt1.to_i)
    @ilr3_prompt2 = Prompt.find_by_id(@test.ilr3_prompt2.to_i)

    # data = {:message => @ilr1_prompt1.video.empty?, :status => "false"}
    # render :json => data, :status => :ok

  end

  # GET /tests/new
  def new
    if !@current_user.admin?
      redirect_to '/home'
    end

    @test = Test.new
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

    # data = {:message => @all_lang_prompt_hash.to_json, :status => "false"}
    # render :json => data, :status => :ok

  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new

    @test[:status] = params[:status].to_i
    @test[:title] = params[:title]
    @test[:language] = params[:language]
    @test[:industry] = params[:industry]
    @test[:description] = params[:description]
    @test[:time] = params[:time]
    @test[:price] = params[:price]
    @test[:ilr1_prompt1] = params[:ilr1_prompt1]
    @test[:ilr1_prompt2] = params[:ilr1_prompt2]
    @test[:ilr1plus_prompt1] = params[:ilr1plus_prompt1]
    @test[:ilr1plus_prompt2] = params[:ilr1plus_prompt2]
    @test[:ilr2_prompt1] = params[:ilr2_prompt1]
    @test[:ilr2_prompt2] = params[:ilr2_prompt2]
    @test[:ilr2plus_prompt1] = params[:ilr2plus_prompt1]
    @test[:ilr2plus_prompt2] = params[:ilr2plus_prompt2]
    @test[:ilr3_prompt1] = params[:ilr3_prompt1]
    @test[:ilr3_prompt2] = params[:ilr3_prompt2]

    # data = {:message => params[:ilr3_prompt2], :status => "false"}
    # render :json => data, :status => :ok

    if @test.title.to_s == "" || @test.language.to_s == "" || @test.industry.to_s == "" || @test.description.to_s == "" || @test.time.to_s == "" || @test.price.to_s == "" || @test.ilr1_prompt1.to_s == "" || @test.ilr1_prompt2.to_s == "" ||
       @test.ilr1plus_prompt1.to_s == "" || @test.ilr1plus_prompt2.to_s == "" || @test.ilr2_prompt1.to_s == "" || @test.ilr2_prompt2.to_s == "" || @test.ilr2plus_prompt1.to_s == "" || @test.ilr2plus_prompt2.to_s == "" || @test.ilr3_prompt1.to_s == "" || @test.ilr3_prompt2.to_s == ""
      redirect_to new_test_path, notice: "Please fill in all required fields"
    end


    respond_to do |format|
      if @test.save
        format.html { redirect_to tests_path, notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: @test }
      else
        format.html { render :new }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to tests_url, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def add_to_cart
    @test = params[:test]
    session[:tests] ||= []
    session[:tests] << @test
    session[:cart_expires_at] = Time.current + 2.hours
    data = {:message => session[:tests], :status => "true"}
    render :json => data, :status => :ok
  end

  # def add_to_cart
  #   @cart_items = session[:tests]
  #   if !@cart_items.nil?
  #     @cart_items = @cart_items.map{|ci| ci.to_i}
  #     @cart_items.each do |cart_item|
  #       current_cart.add_test_to_cart(cart_item)
  #     end
  #
  #     session[:tests] = nil
  #     $tests = []
  #     data = {:message => "added to cart", :cart => current_cart, :status => "true"}
  #     render :json => data, :status => :ok
  #     return redirect_to carts_path
  #
  #   else
  #     return redirect_to carts_path
  #   end
  # end

  def buy_test_after_login
    @test = Test.find_by_id(params[:test])
    session[:tests] ||= []

    session[:tests] << @test.id
    session[:total_price] = @test.price

    redirect_to checkout_path

  end

  def close_test
    @test_record = TestRecord.find_by_id(params[:test_record_id])

    # data = {:message => @test_record :status => "false"}
    # render :json => data, :status => :ok

    # @test_record.update_attribute(:status => 1)
    redirect_to "/finished_test"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.fetch(:test, {})

      params.require(:test).permit(:title, :description, :price, :time, :status, :language, :industry, :ilr1_prompt1, :ilr1_prompt2, :ilr1plus_prompt1, :ilr1plus_prompt2, :ilr2_prompt1, :ilr2_prompt2, :ilr2plus_prompt1, :ilr2plus_prompt2, :ilr3_prompt1, :ilr3_prompt2)
    end
end
