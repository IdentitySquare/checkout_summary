class CheckoutSummary

  attr_reader :discounts

  #the default value for accumulate is true unless specified or set to be false
  def initialize(**args)
    @accumulate = args[:accumulate] || args[:accumulate] == nil
    @discounts = {}
  end

  def add_discount(**args)

    name = args[:name]
    amount = args[:amount]
    percentage = args[:percentage]


    if amount.is_a?(String) || percentage.is_a?(String) || amount.to_i < 0  
      raise StandardError.new "Not a valid deal"
    elsif amount == nil && percentage == nil
      raise StandardError.new "Not a valid deal"
    elsif percentage.to_i > 100 || percentage.to_i < 0
      raise StandardError.new "Not a valid deal"
    end

    @discounts[name] = {
      name: name,
      amount: amount,
      percentage: percentage
    }

    true
  end

  

  def accumulate?
    @accumulate
  end

  def remove_discount!(discount_name)
    @discounts.delete(discount_name)
  end

  
  def calculate_discount_accumulate_true(fullcost)
    cost = fullcost 
    discounted_amounts = []

    @discounts.each do |_key,discount|
      return 0 if discount[:amount].to_i > fullcost || discount[:percentage].to_i == 100
      if discount[:percentage]
        percentage_off = cost * (discount[:percentage] / 100.to_f)
      end

      discounted_amounts =  [discount[:amount], percentage_off].compact.max
      cost = cost - discounted_amounts
    end
    cost
  end

  def calculate_discount_accumulate_false(cost)
    discounted_amounts = []

    @discounts.each do |_key, discount|
      return 0 if discount[:amount].to_i >= cost || discount[:percentage].to_i >= 100

      if discount[:percentage]
        percentage_off = cost * (discount[:percentage] / 100.to_f)
      end

      discounted_amounts << [discount[:amount], percentage_off].compact.max
    end
    cost - discounted_amounts.sum
  end

  def calculate_discount(fullcost)
    if @accumulate  
      calculate_discount_accumulate_true(fullcost)
    else
      calculate_discount_accumulate_false(fullcost)
    end
  end

end
