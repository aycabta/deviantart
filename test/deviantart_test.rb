require 'test_helper'
require 'deviantart'
require 'deviantart/version'

describe DeviantArt do
  describe "version number" do
    it "must be had" do
      refute_nil(::DeviantArt::VERSION)
    end
  end
end
