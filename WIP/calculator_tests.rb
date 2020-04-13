require './calculator.rb'


class Calculatortest < Minitest::Test


# --------------------------------------------------
# Test for adding discounts
# --------------------------------------------------

  def test_add_discount
    @price = Calculate.new

    result = @price.add_discount({
    name: "new yeardeal",
    amount: nil,
    percentage: 20

    })

    # result = @price.return_discounts.size

    assert result == true
  end

  def test_add_two_discounts
    @price = Calculate.new

    @price.add_discount({
    name: "new yeardeal",
    amount: nil,
    percentage: 20
    })

    @price.add_discount({
    name: "student_deal",
    amount: 2000,
    percentage: nil
    })

    result = @price.return_discounts.size

    assert result == 2
  end

  def test_if_discount_is_storing_amount_correctly
    @price = Calculate.new

    @price.add_discount({
      name: "new yeardeal",
      percentage: 20
    })

    assert_nil(@price.return_discounts['new yeardeal'][:amount],nil)
  end

  def test_if_discount_is_storing_percentage_correctly
    @price = Calculate.new

    @price.add_discount({
      name: "new yeardeal",
      amount: 2000
    })

    assert_nil(@price.return_discounts['new yeardeal'][:percentage],nil)
  end


  def test_add_three_discounts

    @price = Calculate.new

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
    @price = Calculate.new

    assert_raises "Not a valid deal" do
      @price.add_discount({
      name: "new yeardeal",
      amount: 67789,
      percentage: 109
      })
    end
  end


  def test_add_two_nil_parameters
    @price = Calculate.new

    assert_raises "Not a valid deal" do
      @price.add_discount({
      name: "new yeardeal",
      amount: nil,
      percentage: nil
      })
    end
  end


  def test_add_invalid_amount_percentage
    @price = Calculate.new

    assert_raises "Not a valid deal" do
      @price.add_discount({
      name: "new yeardeal",
      amount: nil,
      percentage: nil
      })
    end
  end


  def test_add_string_parameters
    @price = Calculate.new

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
    setup_one_discount 
    result = @price.remove_discount!("new years deal")
    assert result[:name] == "new years deal"
  end

  def delete_non_existing_discount
    setup_one_discount
    result = @price.remove_discount!("non existing plan")
    assert result == nil
  end


  # -------------------------------------------------------------
  # Test for discount net amount(1 discount)
  # -------------------------------------------------------------

  [[10000, 8000]].each do |test_case|
    define_method("test_for_a_discount_#{test_case[0]}_one") do
      setup_one_discount
      
      result = @price.calculate_discount(test_case[0])
      assert_equal test_case[1], result
    end
  end

  # -------------------------------------------------------------
  # Test for discount net amount(1 discount) different amount & percentage
  # -------------------------------------------------------------


  [[10000, 5000]].each do |test_case|
    define_method("test_for_a_discount_#{test_case[0]}_one_different_units") do
      setup_one_discount_different
      
      result = @price.calculate_discount(test_case[0])
      assert_equal test_case[1], result
    end
  end


  # -------------------------------------------------------------
  # Test for discount net amount accumulate == false(3 discounts)
  # -------------------------------------------------------------

  [
    [0, 0],
    [100, 0],
    [10000, 4800],
    [25000, 15000],
    [500,  0],
    [70000, 45600],
    [100000, 66000]
    
  ].each do |test_case|
    define_method("test_for_discount_#{test_case[0]}_accumulate_false") do
      setup_three_discounts({accumulate: false})
      
      result = @price.calculate_discount(test_case[0])
      assert_equal test_case[1], result
    end
  end

  # --------------------------------------------------
  # Test for discount net amount accumulate == true (3 discounts)
  # --------------------------------------------------


  [
    [0, 0],
    [100, 0],
    [10000, 5280],
    [25000, 15840],
    [500,  0],
    [70000, 47520],
    [100000, 68640]
    
  ].each do |test_case|
    define_method("test_for_discount_#{test_case[0]}_accumulate_true") do
      setup_three_discounts({accumulate: true})

      result = @price.calculate_discount(test_case[0])
      assert_equal test_case[1], result
    end    
  end

  # -------------------------------------------------------------
  # Test for discount net amount accumulate == false(5 discounts)
  # -------------------------------------------------------------


  [
    [0, 0],
    [100, 0],
    [10000, 4670],
    [25000, 14720],
    [500,  0],
    [150000, 98470],
    [50000, 31470]
   
    ].each do |test_case|
    define_method("test_for_five_discount_#{test_case[0]}_accumulate_false") do
      setup_five_discounts({accumulate: false})

      result = @price.calculate_discount(test_case[0])
      assert_equal test_case[1], result
    end    
  end

  # -------------------------------------------------------------
  # Test for discount net amount accumulate == true(5 discounts)
  # -------------------------------------------------------------

  [
    [0, 0],
    [100, 0],
    [10000, 5197.5],
    [25000, 15651.9],
    [500,  0],
    [150000, 102771.9],
    [50000, 33075.9]
   
    ].each do |test_case|
    define_method("test_for_five_discount_#{test_case[0]}_accumulate_true") do
      setup_five_discounts({accumulate: true})

      result = @price.calculate_discount(test_case[0])
      assert_equal test_case[1], result
    end    
  end




  



  private

  def setup_one_discount
    @price = Calculate.new

    @price.add_discount({
      name: "new years deal",
      amount: nil,
      percentage: 20
    })

  end

  def setup_one_discount_different
    @price = Calculate.new

    @price.add_discount({
      name: "new years deal",
      amount: 5000,
      percentage: 7
    })

  end

  def setup_three_discounts(**args)
    @price = Calculate.new(args)

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

    @price.add_discount({
      name: "staff_discount",
      amount: nil,
      percentage: 12
    })
  end

  def setup_five_discounts(**args)
    @price = Calculate.new(args)

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

    @price.add_discount({
      name: "staff_discount",
      amount: nil,
      percentage: 12
    })

    @price.add_discount({
      name: "gift_deal",
      amount: 30,
      percentage: nil
    })

    @price.add_discount({
      name: "special_offer",
      amount: 12 ,
      percentage: 1
    })



  end

end
