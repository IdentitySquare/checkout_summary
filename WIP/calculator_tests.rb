require './calculator.rb'


class Calculator_Test < Minitest::Test

# -------------------------------------------------------------
# -------------------------------------------------------------
#                    UNIT TESTS
# -------------------------------------------------------------
# -------------------------------------------------------------


# --------------------------------------------------
# Test for adding discounts
# --------------------------------------------------

  def test_add_discount
    @price = CheckoutSummary.new({accumulate: false})

    result = @price.add_discount({
      name: "new yeardeal",
      amount: nil,
      percentage: 20

    })

    assert result == true
  end

  def test_add_two_discounts
    @price = CheckoutSummary.new({accumulate: false})

    @price.add_discount({
      name: "new yeardeal",
      amount: nil,
      percentage: 20
    })

    result = @price.add_discount({
      name: "student_deal",
      amount: 2000,
      percentage: nil
    })

    

    assert result == true
  end

  def test_if_discount_is_storing_amount_correctly
    @price = CheckoutSummary.new({accumulate: false})

    @price.add_discount({
      name: "new yeardeal",
      percentage: 20
    })

    assert_nil(@price.discounts['new yeardeal'][:amount],nil)
  end

  def test_if_discount_is_storing_percentage_correctly
    @price = CheckoutSummary.new({accumulate: false})

    @price.add_discount({
      name: "new yeardeal",
      amount: 2000
    })

    assert_nil(@price.discounts['new yeardeal'][:percentage],nil)
  end


  def test_add_three_discounts

    @price = CheckoutSummary.new({accumulate: false})

    @price.add_discount({
      name: "new year deal",
      amount: nil,
      percentage: 20
    })

    @price.add_discount({
      name: "student_deal",
      amount: 2000,
      percentage: nil
    })

    result = @price.add_discount({
      name: "staff_discount",
      amount: nil,
      percentage: 12
    })


    assert result == true

  end 


  def test_add_high_percentage
    @price = CheckoutSummary.new({accumulate: false})

    assert_raises "Not a valid deal" do
      @price.add_discount({
        name: "new yeardeal",
        amount: 67789,
        percentage: 109
      })
    end
  end


  def test_add_two_nil_parameters
    @price = CheckoutSummary.new({accumulate: false})

    assert_raises "Not a valid deal" do
      @price.add_discount({
        name: "new yeardeal",
        amount: nil,
        percentage: nil
      })
    end
  end


  def test_add_invalid_amount_percentage
    @price = CheckoutSummary.new({accumulate: false})

    assert_raises "Not a valid deal" do
      @price.add_discount({
        name: "new yeardeal",
        amount: nil,
        percentage: nil
      })
    end
  end


  def test_add_string_parameters
    @price = CheckoutSummary.new({accumulate: false})

    assert_raises "Not a valid deal" do
      @price.add_discount({
        name: "new yeardeal",
        amount: "hello",
        percentage: "ruby"
      })
    end

  end


  # --------------------------------------------------
  # Test for removing discounts 
  # --------------------------------------------------

  def test_delete_one_discount
    setup_one_discount({accumulate: false})
    result = @price.remove_discount!("new years deal")
    assert result[:name] == "new years deal"
  end

  def delete_non_existing_discount
    setup_one_discount
    result = @price.remove_discount!("non existing plan")
    assert result == nil
  end

  # --------------------------------------------------
  # Test for adding an item 
  # --------------------------------------------------

  def test_add_one_item
    @price = CheckoutSummary.new
    result = @price.add_item({
      name: "pen",
      quantity: 1 ,
      cost:  50
    }) 
    assert result == true
  end 

  def test_add_two_items
    @price = CheckoutSummary.new

    @price.add_item({
      name: "duster",
      quantity: 1 ,
      cost:  42
    })

    result = @price.add_item({
      name: "pen",
      quantity: 1 ,
      cost:  50
    })

    assert result == true
  end

  def test_add_item_name_nil
    assert_raises "Not a valid item" do
      @price.add_item({
        name:"",
        quantity: 2,
        cost: 700
      })
    end
  end

  def test_add_item_quantity_string
    assert_raises "Not a valid item" do
      @price.add_item({
        name:"boxes",
        quantity: "xxx",
        cost: 700
      })
    end
  end

  def test_add_item_quantity_nil
    assert_raises "Not a valid item" do
      @price.add_item({
        name:"boxes",
        quantity: nil,
        cost: 700
      })
    end
  end

  def test_add_item_cost_nil
    assert_raises "Not a valid item" do
      @price.add_item({
        name:"boxes",
        quantity: 56,
        cost: nil
      })
    end
  end

  def test_add_item_cost_is_string
    assert_raises "Not a valid item" do
      @price.add_item({
        name:"boxes",
        quantity: 56,
        cost: "hello"
      })
    end
  end

  # --------------------------------------------------
  # Test for removing an item 
  # --------------------------------------------------

  def test_remove_existing_item
    setup_one_item
    result = @price.remove_item!("pen")
    assert result[:name] == "pen"
  end

  def test_remove_non_existing_item
    setup_one_item
    result = @price.remove_item!("xyz")
    assert result == nil
  end

  def test_remove_nil_item
    setup_one_item
    result = @price.remove_item!(nil)
    assert result == nil
  end

  def test_remove_empty_string
    setup_one_item
    result = @price.remove_item!("")
    assert result == nil
  end


  # -------------------------------------------------------------
  # -------------------------------------------------------------
  #                    INTEGRATION TESTS
  # -------------------------------------------------------------
  # -------------------------------------------------------------
  


  


  [
    {
      accumulate: true,
      items: [{c: 100}],
      discounts: [{p: 20}],
      result: 80
    },
    {
      accumulate: true,
      items: [{c: 200, q: 2}, {c: 100, q: 1}],
      discounts: [{a: 200, p: 30}],
      result: 300
    },

    {
      accumulate: true,
      items: [{c: 2000, q: 3}],
      discounts: [{a: 90, p: 10}, {a: 70}],
      result: 5330 
    },

    {
      accumulate: false,
      items: [{c: 3750, q: 2}],
      discounts: [{a: 90, p: 10}, {a: 70}],
      result: 6680 
    },

    {
      accumulate: false,
      items: [{c: 3750, q: 2},{c: 1000, q: 3}],
      discounts: [{a: 30000}],
      result: 0 
    },

    {
      accumulate: false,
      items: [{c: 3750, q: 2}],
      discounts: [{a: 500, p: 50},{a: 5000}],
      result: 0 
    },

    {
      accumulate: true,
      items: [{c: 2000, q: 2},{c: 3000}],
      discounts: [{a: 500, p: 50},{a: 20}],
      result: 3480
    },

    {
      accumulate: false,
      items: [{c: 1250, q: 2},{c: 3000, q: 1}],
      discounts: [{a: 500, p: 8},{a: 20, p: 3}],
      result: 4835
    }

  ].each do |test|

    define_method("test_integration_#{test[:items].count}_#{test[:discounts].count}_#{test[:accumulate]}_#{test[:result]}") do

      setup_base(test[:accumulate])
      setup_items(test[:items])
      setup_discounts(test[:discounts])

      assert_equal test[:result], @price.calculate[-1][:value]
    end

  end


  



  private


  def setup_base(accumulate=true)
    @price = CheckoutSummary.new({
      accumulate: accumulate
    })
  end

  def setup_items(items=[])
    items.each do |item|
      name = "item_#{item[:c]}_#{item[:q]}"

      @price.add_item({
        name: name,
        quantity: item[:q],
        cost: item[:c]
      })
    end
  end


  def setup_discounts(discounts=[])
    discounts.each do |discount|
      name = "discount_#{discount[:a]}_#{discount[:p]}"

      @price.add_discount({
        name: name,
        amount: discount[:a],
        percentage: discount[:p]
      })
    end
  end

  # -------------------------------------------------------------
  # Setup for discounts
  # -------------------------------------------------------------


  def setup_one_discount_full_discount(**args)
    @price = CheckoutSummary.new(args)

    @price.add_discount({
      name: "new years deal",
      amount: nil,
      percentage: 100
    })

  end

  def setup_one_discount(**args)
    @price = CheckoutSummary.new(args)

    @price.add_discount({
      name: "new years deal",
      amount: nil,
      percentage: 20
    })

  end

  def setup_one_discount_different(**args)
    @price = CheckoutSummary.new(args)

    @price.add_discount({
      name: "new years deal",
      amount: 5000,
      percentage: 7
    })

  end

  
  def setup_one_item

    @price = CheckoutSummary.new

    @price.add_item({
      name: "pen",
      quantity: 1 ,
      cost:  50
    })


  end

end
