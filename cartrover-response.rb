require 'json'

# CartRover API Response
#
# Convenience wrapper for CartRover JSON response.
# Represents both a successful and unsuccessful API request.
#
# @author Devon Anderson
#

class CartRoverResponse
	# Initialize
	#
	# @param [Object #response] The API response
	def initialize(response)
		@code = defined?(response.code) ? response.code : response.http_code
		@headers = {}
		@cookies = {}
		@history = {}
		@response = {}
		@success = false

		if @code === 200
			data = JSON.parse(response.body.to_s)

			@headers = response.headers
			@cookies = response.cookies
			@history = defined?(response.history) ? response.history : {}
			@success = data['success_code']

			if @success
				@response = data['response']
			else
				@response = {
					'error' => data['error_code'],
					'message' => data['status_message'] || data['message'],
					'api_hits_remaining' => @headers['X-CartRover-Api-Minute-Hits-Remaining']
				}
			end
		else
			@headers = defined?(response.http_headers) ? response.http_headers : {}

			@response = {
				'error' => response.http_code,
				'message' => response.message
			}
		end
	end

	def to_s
		return "{ \"code\": #{@code}, \"success\": #{@success}, \"headers\": #{JSON.generate(@headers)}, \"cookies\": #{JSON.generate(@cookies)}, \"history\": #{JSON.generate(@history)}, \"response\": #{JSON.generate(@response)} }"
	end
end