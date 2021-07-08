require_relative 'grocer'

def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

def generate_cart
	[].tap do |cart|
		rand(20).times do
			cart.push(items.sample)
		end
	end
end

def generate_coupons
	[].tap do |c|
		rand(2).times do
			c.push(coupons.sample)
		end
	end
end

cart = generate_cart
coupons = generate_coupons

puts "Items in cart"
cart.each do |item|
	puts "Item: #{item.keys.first}"
	puts "Price: #{item[item.keys.first][:price]}"
	puts "Clearance: #{item[item.keys.first][:clearance]}"
	puts "=" * 10
end

puts "Coupons on hand"
coupons.each do |coupon|
	puts "Get #{coupon[:item].capitalize} for #{coupon[:cost]} when you by #{coupon[:num]}"
end

puts "Your total is #{checkout(cart: cart, coupons: coupons)}"



def consolidate_cart(cart:[])
  my_hash = {}

  cart.each do |item|
    item.each do |itemname, data|
      if my_hash[itemname] == nil
        my_hash[itemname] = data
        my_hash[itemname][:count] = 1
      else
        my_hash[itemname][:count] += 1
      end
    end
  end
  my_hash
end

def apply_coupons(cart:[], coupons:[])

  my_hash = {}
  if coupons == nil || coupons.empty?
    my_hash = cart
  end
  coupons.each do |coupon|
    cart.each do |itemname, data|
      if itemname == coupon[:item]
        count = data[:count] - coupon[:num]

        if count >= 0
          if my_hash["#{itemname} W/COUPON"] == nil
            my_hash["#{itemname} W/COUPON"] = {price: coupon[:cost], clearance: data[:clearance], count: 1}
          else
            couponcount = my_hash["#{itemname} W/COUPON"][:count] + 1
            my_hash["#{itemname} W/COUPON"] = {price: coupon[:cost], clearance: data[:clearance], count: couponcount}
          end
        else
          count = data[:count]
        end
        my_hash[itemname] = data
        my_hash[itemname][:count] = count
      else
        my_hash[itemname] = data
      end
    end
  end
  my_hash
end

def apply_clearance(cart:[])

  cart.each do |itemname, data|
    if data[:clearance]
      discount = data[:price] * 0.8
      data[:price] = discount.round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
end
  cart = consolidate_cart(cart:cart)
  cart = apply_coupons(cart:cart, coupons:coupons)
  cart = apply_clearance(cart:cart)
  total = 0
  cart.each do |itemname, data|
    total += ( data[:price] * data[:count] )
  end
  if total > 100
    puts total
    total = total - (total * 0.1 )

  end
  total
end
