class Calculate

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

  def return_discounts
    @discounts
  end

  def accumulate?
    @accumulate
  end

  def remove_discount!(discount_name)
    @discounts.delete(discount_name)
  end

  
  def calculate_discount_accumulate_true(fullcost)
    cost = fullcost 

    @discounts.each do |_key,discount|
      return 0 if discount[:amount].to_i > fullcost || discount[:percentage].to_i == 100
      if discount[:amount] != nil && discount[:percentage] != nil
        if discount[:amount] > (discount[:percentage]/100.to_f)*cost
          discount[:percentage] = nil
        else
          discount[:amount] = nil
        end
      end
      if discount[:amount] != nil
        cost = cost - discount[:amount]
      else
        cost = cost - ((discount[:percentage]/100.to_f)*cost)
      end
    end
    cost
  end

  def calculate_discount_accumulate_false(fullcost)
    discounted_net = []
    cost = fullcost
    @discounts.each do |_key,discount|
      return 0 if discount[:amount].to_i > fullcost || discount[:percentage] == 100
      if discount[:amount] != nil && discount[:percentage] != nil
        if discount[:amount] > (discount[:percentage]/100.to_f)*cost
          discount[:percentage] = nil
        else
          discount[:amount] = nil
        end
      end
      if discount[:amount] == nil
        discounted_net << ((discount[:percentage]/100.to_f)* fullcost)
      else
        cost = cost - discount[:amount]
      end
    end
    (cost - (discounted_net.sum)).to_f
  end

  def calculate_discount(fullcost)
    if @accumulate  
      calculate_discount_accumulate_true(fullcost)
    else
      calculate_discount_accumulate_false(fullcost)
    end
  end

end
