def consolidate_cart(cart)
  new_hash = {}
  cart.each do |cart_array|
    cart_array.each do |item, info_hash|
      new_hash[item] ||= info_hash
      new_hash[item][:count] ||= 0
      new_hash[item][:count] += 1
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  with_coupons = apply_coupons(consolidated, coupons)
  total_cart = apply_clearance(with_coupons)
  total_price = 0
  total_cart.each do |item, info|
    total_price += info[:price] * info[:count]
  end
  if total_price > 100
    total_price = total_price * 0.9
  end
  total_price
end
