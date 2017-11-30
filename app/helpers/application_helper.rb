module ApplicationHelper
  def render_cart_items_count
    if !session[:tests].nil?
      session[:tests].count
    else
      0
    end
  end
end
