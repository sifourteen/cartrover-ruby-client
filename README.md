# Ruby CartRover API client

A simple Ruby client for interacting with CartRover API

## Requirements
* Ruby >= 2.0
* Bundler >= 1.10


## Installation

`git clone https://github.com/sifourteen/cartrover-ruby-client.git` 

`cd cartrover-ruby-client`

`bundle install`

## Usage

```
require './cartrover-ruby-client/cartrover'

# You will need your CartRover API credentials to use this client
cartrover = CartRover.new('<API_USER>', '<API_KEY>')

# Now you can start making requests to the CartRover API.
# Full docs for the API can be found here => [API DOCUMENTATION](https://cartrover.atlassian.net/wiki/display/CART/CartRover+API+Documentation)

# Create a new order
cartrover.new_order({ ... })

# Returns order information in the 'New Order' format
cartrover.view_order(ref: '<ORDER_REF>', merchant: false)

# Returns the status and tracking info for a particular order
cartrover.view_order_status(ref: '<ORDER_REF>', merchant: false)

# Cancels an existing order. This call is only available for a few minutes after the order has been created.
cartrover.cancel_order({ ... })

# Returns inventory levels for a particular product
cartrover.product_inventory(sku: '<PRODUCT_SKU>')

# Returns inventory levels for all products under a merchant
cartrover.merchant_inventory({ ... })

# Returns all acceptable warehouse shipping methods
cartrover.ship_methods()
```