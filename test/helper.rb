$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'deviantart'

require 'minitest/autorun'
require 'webmock/minitest'
require 'json'

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  data = File.new(fixture_path + '/' + file).read
  data.instance_eval do
    def json
      @json ||= JSON.parse(self)
    end
  end
  data
end

