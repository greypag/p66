class HomesController < ApplicationController
  before_action :anti_authuser

  def aboutthetests
    @tests = Test.all
  end

  def cart_number_reload
    render :partial => 'header'
  end

    def thankyou
        if session[:sign_up_email] == nil
            redirect_to "/"
        end
    end


    def active_link_fail

    end


    def active_link_done

    end
end
