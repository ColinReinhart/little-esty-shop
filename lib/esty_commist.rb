require 'httparty'
require 'json'
require 'pry'

response = HTTParty.get("https://api.github.com/repos/ColinReinhart/little-esty-shop/commits")

response.body

parsed = JSON.parse(response.body, symbolize_names: true)

class Commit
  attr_reader :author

  def initialize(data)
    @author = data(:author)
  end
end

commits = parsed.map do |data|
  Commit.new(data)
end

commits.each do |film|
  puts commit.author
end
require "pry"; binding.pry
