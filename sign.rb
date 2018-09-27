require 'eth'


key  = Eth::Key.new(priv: '25d5a2003105695914691919fb654bdcc723daf805766753ac8e33d0ff428e58')
code = ARGV[0].strip

puts '-' * 30
puts key.address
puts key.personal_sign(code)
puts '-' * 30
