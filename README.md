# Checkout_summary
Calculate the checkout summary after you purchase a product. This summary will provide you a breakdown of the price that leads to the net amount charged.

## 🛠 Installation
Add this line to your application's Gemfile:

```ruby
gem 'checkout_summary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install checkout_summary 
    
## 🚸 Basic Usage Example


## 🎟 Options

### Initializing

``` ruby
CheckoutSummary.new({
    accumulate: true
    gross_cost: 25000
})
```
* `accumulate` *(optional, default `true`)*: Set to `false` to calculate discount percentage from the full cost given.

* `grosscost` *(required)*: integer or decimal
* calculate_discount_accumulate_true
the discount percentage will be dedcuted from the fullcost and the consecutive discount percentage will be dedeucted as a percentage of the net amount.
* calculate_discount_accumulate_false
the discount perecentage is dedecuted from the full amount. Every percentage int the plans list will be deducted as a percentage of the full amount.



### Adding a discount

``` ruby
@price.add_discount({
    name: 'Student_discount',
    amount: 75,
    percentage: 34
})
```

* `name` *(required)*: a unique identifier for each plan
* `amount` : the amount to be taken off the the full cost. This should be provided in cents.
* `percentage` : the percentage of the discount plan indicating the percentage to be taken off the full amount to give a reduced price.
*Either discount or percentage can be given. Both parameters are not necessary , however both parameters cannot be nil*

### Removing a discount

``` ruby
# remove a discount deal with it's unique name
price.remove_discount('student_deal')
```

### Other methods
``` ruby
# a list of discounts that are setup. Returns a hash of price objects
price.discounts
```

### Calculating net amount

``` ruby
price.calculate_discount
# returns an array of gross amount, the breakdown of the discounts and the final net amount.

[{name: 'gross_amount',
  type:'gross',
  value: 4000
   },
{name: 'student_deal',
  type: "discount",
  value: 300
   },
   {name: 'net_amount',
  type: 'net',
  value: 3700
   }]
   
   
```

``` ruby

discount_array =  @price.calculate
discount_array.each do |item|
 puts "#{item[:name].capitalize}: #{item[:value]}"
end

#This code runs to return the gross_cost, discount breakdown and net_amount in a readable format 

Gross_amount: 50000
New year deal: 10000.0
Student_deal: 2000
Staff_discount: 6000.0
Gift_deal: 30
Special_offer: 500.0
Net_amount: 31470.0

```
















```

