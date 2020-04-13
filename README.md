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
    @accumulate: true
})
```
* `accumulate` *(optional, default `true`)*: Set to `false` to calculate discount percentage from the full cost given.

### Adding a discount plan

``` ruby
@price.add_discount({
    name: 'Student_discount',
    amount: nil,
    percentage: 34
})
```

* `name` *(required)*: a unique identifier for each plan
* `amount` : the amount to be taken off the the full cost. This should be provided in cents.
* `percentage` : the percentage of the discount plan indicating the percentage to be taken off the full amount to give a reduced price.
*Either discount or percentage can be given. Both parameters are not necessary , however both parameters cannot be nil*

### Removing a plan

``` ruby
# remove a discount deal with it's unique name
price.remove_discount('Student_deal')
```

### Other methods
``` ruby
# a list of discounts that are setup. Returns a hash of price objects
price.discounts
```

### Calculating net amount

``` ruby
price.calculate_discount(fullcost)
```

* `fullcost` *(required)*: integer or decimal



### Accumulate = true / Accumulate = false
How did we get to the final net amount charge.

``` ruby
net_amount = price.calculate_discount_accumulate_true(fullcost)
or 
net_amount = price.calculate_discount_accumulate_false(fullcost)



# calculate_discount_accumulate_true(fullcost)
the discount percentage will be dedcuted from the fullcost and the consecutive discount percentage will be dedeucted as a percentage of the net amount.
# calculate_discount_accumulate_false(fullcost)
the discount perecentage is dedecuted from the full amount. Every percentage int the plans list will be deducted as a percentage of the full amount.



```

