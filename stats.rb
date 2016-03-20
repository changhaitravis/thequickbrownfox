#!/usr/bin/ruby

require "redis"
$redis = Redis.new

def action(arg)
    case arg
    when "leaderboard"
        puts $redis.zrange("pangram", 0, -1, "WITHSCORES")
    when "alphabet"
        puts $redis.hgetall("stats:alphabet")
    else 
        puts "No words recognized"
        ask()
    end
end

def ask
    puts "what would you like to see? /r/n leaderboard? /r/n alphabet?"
    action(gets.chomp)
end

if ARGV != nil
    action(ARGV[0])
else
    ask()
end
