require 'pry'

def consolidate_cart(cart)
  newList = {}
  
  cart.each do |itemA|
    itemA.each do |itemB,valA|
      if newList[itemB] != nil
        newList[itemB][:count] += 1
      else
        newList[itemB] = valA
        newList[itemB][:count] = 1
      end
    end
  end
  
  return newList
end

def apply_coupons(cart, coupons)
  
  newListA = cart
  
  coupons.each do |itemA|
    itemName = itemA[:item]
    
    if newListA[itemName] && newListA[itemName][:count] >= itemA[:num]
      
      tempVal = newListA[itemName][:count] / itemA[:num]
      newListA[itemName][:count] -= itemA[:num]
      tempKey = "#{itemName} W/COUPON"
      tempItem = {tempKey => {:price => itemA[:cost], :clearance => newListA[itemName][:clearance], :count => tempVal}}
      
      if newListA[tempKey] == nil
        newListA.merge!(tempItem)
      end       
    end
  end
     
  return newListA
  
end

def apply_clearance(cart)
  
  newListA = cart
  
  newListA.each do |itemA,valA|
    if valA[:clearance] == true
      valA[:price] =(valA[:price]*0.8).round(2)
    end
  end
  
  return newListA
  
end

def checkout(cart, coupons)
  
  newList = cart
  
  newList = consolidate_cart(newList)
  newList = apply_coupons(newList,coupons)
  newList = apply_clearance(newList)
  
  total = 0
  
  newList.each do |itemA,valA|
    total += valA[:price]*valA[:count]
  end
  
  if total > 100
    total = (total*0.9).round(2)
  end
  
  return total
  
end
