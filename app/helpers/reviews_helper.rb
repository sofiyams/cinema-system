module ReviewsHelper
  def display_stars(rating)
    return "<span class='review_small'>(no reviews)</span>".html_safe if rating.zero?
    display = ""
    5.times do
      checked = rating.positive? ? "checked" :""
      display += "<span class='fa fa-star #{checked}'></span>"
      rating -=1
    end      
    display.html_safe
  end 
end
