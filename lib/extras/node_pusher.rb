# Send an HTTP request to the node server
# Which the sends a signal to the socket

class NodePusher
  class << self
    def publish(action, user, data)
      url = "#{Rails.application.config.node.server}/notify/#{action}/#{user}"
      res = Net::HTTP.post_form(URI.parse(URI.encode(url)), data)

      # 200 implies successfully sent.
      # There is nothing we can do if the targe user is not online(404)
      # For any other error, raise Exception
      unless ["200", "404"].include? res.code
        raise Exception.new("Error: #{res.code}")
      end
    end
  end
end
