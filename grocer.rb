def consolidate_cart(cart)
  contents = {}
  cart.each do |item|
    item.each do |name, info|
      #if item already exists, increase count by 1
      if contents[name]
        contents[name][:count] += 1
        #if item doesn't exist, add it to contents and set count to 1
      else
        contents[name] = info
        contents[name][:count] = 1
      end
    end
  end
  contents
end

def apply_coupons(cart, coupons)
  contents = cart

  coupons.each do |coupon|
    name = coupon[:item]
    number = coupon[:num]
    # if coupon applies to anything in cart & has same or more amount than coupon requires
    if cart.include?(name) && cart[name][:count] >= number
      # decrease number from cart that coupon applied to
      contents[name][:count] -= number
      if contents["#{name} W/COUPON"]
        contents["#{name} W/COUPON"][:count] += number
      else
        contents["#{name} W/COUPON"] = {
          price: coupon[:cost] / number,
          count: number,
          clearance: contents[name][:clearance]
        }
      end
    end
  end
  contents
end

def apply_clearance(cart)
  cart.each do |item, name|
     if name[:clearance] #if clearance is true, take 20% off
       cart[item][:price] = (cart[item][:price] * 0.8).round(2)
     end
  end
  cart
end

def checkout(cart, coupons)
  result = consolidate_cart(cart)
  apply_coupons(result, coupons)
  apply_clearance(result)

  total = 0
  result.each do |item, name|
    total += (name[:price] * name[:count])
  end

  if total > 100
    total = total * 0.9
  end

  total

end
