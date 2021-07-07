require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each_with_object ({}) do |item, result|
#    binding.pry
    item.each do |name, attributes|
      if new_hash[name]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        new_hash[name] = attributes
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  new_cart = {}
  if coupons.empty?
    new_cart = cart
  end
  cart.each do |name, attributes|
    coupons.each do |coupon|
        new_cart[name] = attributes if !new_cart[name] = attributes

        if coupon[:item] == name && coupon[:num] <= attributes[:count]
          if !new_cart["#{name} W/COUPON"]
            new_cart["#{name} W/COUPON"] = {:price => coupon[:cost], :clearance => attributes[:clearance], :count => 1}
            new_cart[name][:count] = new_cart[name][:count] - coupon[:num]
          else
            new_cart["#{name} W/COUPON"][:count] += 1
            new_cart[name][:count] = new_cart[name][:count] - coupon[:num]
        end
      end
    end
  end
  new_cart
end


def apply_clearance(cart)
  new_cart = {}
  cart.each do |name, attributes|
    new_cart[name] = attributes if !new_cart[name]
    long_decimal = ""
    if attributes[:clearance]
      long_decimal = attributes[:price].to_f * 0.8
      new_cart[name][:price] = long_decimal.round(2)
    else
      new_cart[name] = attributes
    end
  end
  new_cart
end



def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated, coupons)
  final_cart = apply_clearance(coupons_applied)
  total = 0
  final_cart.each do |item_name, item_details|
   total += item_details[:price] * item_details[:count]
  end
  total = total * 0.9 if total > 100
  total
end
