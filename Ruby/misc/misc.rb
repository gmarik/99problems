def rev(number, acc = 0)
  if number == 0 then acc
  else rev(number / 10, acc * 10 + (number % 10))
  end
end



def order(money, change)
  change(money, change, acc = [], [], money)
  acc
end

def change(money, change, acc, q, initial)
  if change.empty? || money < 0.0
    if q.inject(0.0,&:+) > initial
        # puts ["%4.2f" % q.inject(&:+), ' = ', q.join('+')].join(' ') 
        # print " ", q.inject(&:+)
    end
    q.pop
    return acc
  end

  if money == 0.0
    acc << q.dup
    return acc 
  end

  h, *t = change

  q << h

  change(money - h, change, acc, q, initial)
  change(money, t, acc, q, initial)
end



