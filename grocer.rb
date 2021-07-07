def consolidate_cart(cart)
  # code here
  new_hash = {}
  cart.each do |array_cart|
    array_cart.each do |item,info|
      if new_hash.has_key?(item) == false
        info[:count] = 1
        new_hash[item] = info
      else 
        new_hash[item][:count] += 1
      end
    end
  end
  return new_hash
end


def apply_coupons(cart, coupons)
  # code here
  new_hash = cart
  #new_hash provides hash with key of food 
  #and value of another hash containing keys of price,clearance,and count
  #with values of                               3, true , 2
  coupons.each do |array_coupon|
    #array_coupon hash of key item, num ,cost 
    # and value of            avocado, 2, 5
    #puts array_coupon[:num]
    food_item = array_coupon[:item] # would equal avocado
   
    if new_hash.has_key?(food_item) == true && new_hash[food_item][:count] >= array_coupon[:num]
      new_hash[food_item][:count] = new_hash[food_item][:count] - array_coupon[:num]
      #puts new_hash[food_item][:count]
      new_item = "#{food_item} W/COUPON"
      if new_hash.has_key?(new_item) == false 
        new_hash[new_item] = {:price => array_coupon[:cost], :clearance => new_hash[food_item][:clearance], :count => 1}
      else
        new_hash[new_item][:count] += 1
      end
    end
  end
  
  #puts new_hash
  return new_hash
end

def apply_clearance(cart)
  # code here
  #puts cart
  cart.each do |food_item,info|
    if info[:clearance] == true
      sale = info[:price] * 0.2
      info[:price] = info[:price] - sale
    end
  end
  return cart
end

def checkout(cart, coupons)
  # code here
  price = 0
  new_hash = consolidate_cart(cart)
  if new_hash.length == 1
    new_hash = apply_coupons(new_hash,coupons)
    new_hash = apply_clearance(new_hash)
    if new_hash.length > 1
      new_hash.each do |key,value|
        price += (value[:price]*value[:count])
      end
    else
      new_hash.each do |key,value|
        price += (value[:price]*value[:count])
      end
    end
  else
    new_hash = apply_coupons(new_hash,coupons)
    new_hash = apply_clearance(new_hash)
    new_hash.each do |key,value|
      price += (value[:price]*value[:count])
    end
  end
 if price > 100
   sale = price * 0.10
   price = price - sale
 end
  return price
end
