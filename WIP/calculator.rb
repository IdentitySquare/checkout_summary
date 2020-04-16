class CheckoutSummary

  attr_reader :discounts, :items
  
  #the default value for accumulate is true unless specified or set to be false
  
  def initialize(**args)
    @accumulate = args[:accumulate] || args[:accumulate] == nil
    @discounts = {}
    @items = {}
      
  end
  

  def add_item(**args)

    name = args[:name]
    quantity = args[:quantity] || 1
    cost = args[:cost]


    if !quantity.is_a?(Integer) || cost.is_a?(String) || cost == nil || name == nil
      raise StandardError.new "Not a valid item"
    end

    @items[name] = {
      name: name,
      quantity: quantity,
      cost: cost 
    }

    true
  end

  def gross_cost
    gross = 0
    @items.each do |_key, value|
      gross = gross + value[:cost] * value[:quantity]
    end
    gross
  end

  
  
  

  def remove_item!(item_name)
    @items.delete(item_name)
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

  def return_items
    list = []
    @items.each do |_key,value|
      list << value
    end
    list
  end


  def remove_discount!(discount_name)
    @discounts.delete(discount_name)
  end

  
  def calculate
    if @accumulate  
      calculate_discount_accumulate_true
    else
      calculate_discount_accumulate_false
    end
  end


  private

  def calculate_discount_accumulate_true
    cost = gross_cost
    discounted_amounts = []
    discount_breakdown = []
    discount_breakdown << return_items
    discount_breakdown << {name: 'gross', type:'gross', value: gross_cost}


    @discounts.each do |_key,discount|
      if discount[:amount].to_i > gross_cost || discount[:percentage].to_i == 100
        return [{name: discount[:name], type: "net" ,value: 0}]
      end
      if discount[:percentage]
        percentage_off = cost * (discount[:percentage] / 100.to_f)
      end

      discounted_amounts =  [discount[:amount], percentage_off].compact.max

      discount_breakdown << {
        name: discount[:name],
        type: "discount",
        value: discounted_amounts
      }

      cost = cost - discounted_amounts
    end

    if cost < 0
      discount_breakdown << {name: "net_amount", type: "net", value: 0}
    else
      discount_breakdown << {name: "net_amount", type: "net", value: cost}
    end
    discount_breakdown.flatten
  end

  def calculate_discount_accumulate_false
    discounted_amounts = []
    discount_breakdown = []
    discount_breakdown << return_items
    discount_breakdown << {name: "gross_amount", type: "gross", value: gross_cost}

    @discounts.each do |_key, discount|

      if discount[:percentage]
        percentage_off = gross_cost * (discount[:percentage] / 100.to_f)
      end

      discounted_amounts << [discount[:amount], percentage_off].compact.max
      discount_breakdown << {name: discount[:name],
      type: "discount",
      value: discounted_amounts.last}
    
    end

    gross_amount = gross_cost - discounted_amounts.sum

    if gross_amount < 0
      discount_breakdown << {name: "net_amount", type: "net", value: 0}
    else
      discount_breakdown << {name: "net_amount", type: "net", value: gross_amount}
    end
    discount_breakdown.flatten
  end

end