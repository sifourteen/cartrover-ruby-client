require 'rest-client'
require 'uri'
require './cartrover-response'


# CartRover API Client
#
# A lightweight API wrapper class for interacting with the CartRover API. 
# Provides a set of convenience methods for making/processing requests made 
# to each of the CartRover endpoints 
#
# For documentation @see https://cartrover.atlassian.net/wiki/display/CART/CartRover+API+Documentation
#
# @author Devon Anderson 
#

module HTTP_Verb
	GET = 'get'
	POST = 'post'
	PUT = 'put'
	DELETE = 'delete'
end

class CartRover	
	# Initialize the client with your CartRover API username and API key
	#
	# @param [String #user] API username
	# @param [String #key] API key
	def initialize(user, key)
		@user = user
		@key = key

		@base_url = 'api.cartrover.com'
		@version = 'v1'
		@protocol = 'https'
	end

	# Creates a new product order
	#
	# @param [Hash #params] The parameters for the endpoint @see https://cartrover.atlassian.net/wiki/pages/viewpage.action?pageId=3997742
	def new_order(params={})
		url = self.build_url(@protocol, 'cart/orders/cartrover')
		response = self.make_request(HTTP_Verb::POST, url, params)
		
		return response
	end

	# Returns order information in the 'New Order' format
	#
	# @param [String #ref] The order reference ID
	# @param [Boolean #merchant] If set to true, will use the merchant account endpoint
	def view_order(ref, merchant=false)
		url = self.build_url(@protocol, (merchant ? 'merchant/orders/#{ref}' : 'cart/orders/#{ref}'))
		response = self.make_request(HTTP_Verb::GET, url)

		return response
	end

	# Returns the status and tracking info for a particular order
	#
	# @param [String #rer] The order reference ID
	# @param [Boolean #merchant] If set to true, will use the merchant account endpoint
	def view_order_status(ref, merchant=false)
		url = self.build_url(@protocol, (merchant ? 'merchant/orders/status/#{ref}' : 'cart/orders/status/#{ref}'))
		response = self.make_request(HTTP_Verb::GET, url)

		return response
	end

	# Cancels an existing order. This call is only available for a few minutes after the order has been created.
	#
	# @param [Hash #params] The parameters for the endpoint @see https://cartrover.atlassian.net/wiki/pages/viewpage.action?pageId=3997757
	def cancel_order(params={})
		url = self.build_url(@protocol, 'cart/orders/cancel')
		response = self.make_request(HTTP_Verb::POST, url, params)

		return response
	end

	# Returns inventory levels for a particular product
	#
	# @param [String #sku] The product SKU
	def product_inventory(sku)
		url = self.build_url(@protocol, 'merchant/inventory/#{sku}')
		response = self.make_request(HTTP_Verb::GET, url)

		return response
	end

	# Returns inventory levels for all products under a merchant
	#
	# @params [Hash #params] the parameters for the endpoint @see https://cartrover.atlassian.net/wiki/pages/viewpage.action?pageId=10846218
	def merchant_inventory(params={})
		url = self.build_url(@protocol, 'merchant/inventory', params)
		response = self.make_request(HTTP_Verb::GET, url)

		return response
	end

	# Returns all acceptable warehouse shipping methods
	def ship_methods() 
		url = self.build_url(@protocol, 'wms/shipmethod/list')
		response = self.make_request(HTTP_Verb::GET, url)

		return response
	end

	protected

	# Builds a CartRover formatted url
	#
	# @param [String #protocol] Either HTTP or HTTPS
	# @param [String #endpoint] The specific endpoint to hit
	# @param [Hash #params] The query params to attach to the url
	#
	# @return [String]
	def build_url(protocol, endpoint, params={})
		url = "#{protocol}://#{@base_url}/#{@version}/#{endpoint}?api_user=#{@user}&api_key=#{@key}"

		params.each { |key, value| url += "&#{key}=#{URI.escape(value.to_s)}" }

		puts url

		return url
	end

	# Makes an HTTP request
	#
	# @param [String #method] The HTTP verb to use (GET, POST, PUT, DELETE)
	# @param [String #url] The url to make the request to
	# @param [Hash #params] The payload to include with the request
	def make_request(method, url, params={})
		begin 
			response = RestClient::Request.execute(method: method, url: url, payload: params);

			return CartRoverResponse.new(response)
		rescue RestClient::ExceptionWithResponse => err
			return CartRoverResponse.new(err)
		end
	end
end