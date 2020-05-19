module ReviewsHelper
  def display_stars(rating)
    rating = rating.to_i
    return "<span class='review_small'>(No rating)</span>".html_safe if rating.zero?
    display = ""
    5.times do
      checked = rating.positive? ? "checked" :""
      display += "<span class='fa fa-star #{checked}'></span>"
      rating -=1
    end      
    display.html_safe
  end 
end
