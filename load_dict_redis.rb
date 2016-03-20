#!/usr/bin/ruby

require "redis"
redis = Redis.new

File.open( ARGV[0] ).each do |line|
    redis.sadd("ref:dictionary", line.chomp)
    puts line.chomp
end
