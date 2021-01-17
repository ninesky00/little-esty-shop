module ApplicationHelper
  def format_date(date)
    date.strftime("%A, %B %-d, %Y")
  end

  def name(customer)
    "#{customer.first_name} #{customer.last_name}"
  end

  def percentage(number)
    if number
    number / 100.0
    end
  end
end
