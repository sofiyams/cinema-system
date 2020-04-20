module BookingsHelper
  def build_options_for_ticket_type(tt)
    price = tt.price || TicketType::DefaultPricing[tt.name] || 6 
    (0..12).map{|i| "#{i} #{number_to_currency(price * i, unit:"£")}" }.zip(0..12)
  end

  def total_payable(total,discount)
    difference = total - discount 
    difference > 0 ? difference : 0 
  end 
end
