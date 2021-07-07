# def consolidate_cart(arr)
#   # code here
#   arr.each do |hash|
#   hash[:count] = 0
#   arr.each do |h1|
#     h1.each do |k1, v1|
#       if h1[k1] != hash[k1]
#         hash[:count] += 1
#       else 
#         hash[:count] = 1
#       end
#     end
#     end
#   end.uniq
# end

def consolidate_cart(arr)
  arr.each_with_object({}) { |el, hash| 
    el.each { |k, v|
      if hash[k]
        v[:count] += 1
      else
        v[:count] = 1
        hash[k] = v
      end
    }
  }
end

# def consolidate_cart(cart)
#   cart.each_with_object({}) do |item, result|
#     item.each do |type, attributes|
#       if result[type]
#         attributes[:count] += 1
#       else
#         attributes[:count] = 1
#         result[type] = attributes
#       end
#     end
#   end
# end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
    item = coupon[:item]
    if cart[item] && cart[item][:count] >= coupon[:num]
      if cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count] += 1
      else
        cart["#{item} W/COUPON"] = {:price => coupon[:cost], :count => 1}
        cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
      end
      cart[item][:count] -= coupon[:num]
    end
  }
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |key, hash|
      if hash[:clearance] == true
        hash[:price] = (hash[:price] * 0.8).round(2) 
      end
  end
  cart
end

def checkout(cart, coupons)
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  cart3 = apply_clearance(cart2)

  total = 0
  cart3.each do |k, v|
    total += (cart3[k][:price] * cart3[k][:count])
  end 
  
  if total >= 100
    return total *= 0.9 
  end
  total
end
