require './cartrover'

rover = CartRover.new('465X3U4B9MI', 'OFoh9A8wS5UOqs1')
order = {
	'cust_ref' => '1234567890123456',
	'ship_address_1' => '125 2nd st. #801',
	'ship_city' => 'Oakland',
	'ship_state' => 'CA',
	'ship_zip' => '94607',
	'ship_country' => 'US',
	'item' => 'TEST1',
	'quantity' => '1'
}

puts rover.merchant_inventory()