#!/usr/bin/ruby

require "redis"
require "json"

redis = Redis.new

#check if dictionary set is loaded
raise NoDictionaryError, 'No dictionary has been loaded' if redis.exists('dictionary') == false

#get user input
puts "what is your phrase?"
phrase = gets.downcase.chomp.tr('",.!@#$%^&*()\'\\{}[]<>1234567890;:`~', "")

#create local alphabet array
alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

alphabetHash = Hash.new

$i = 0
for $i in 0..alphabet.size 
    alphabetHash[alphabet[$i]] = 0
end
total = 0
max = 0

$i = 0
for $i in 0..phrase.size
    if alphabetHash[phrase[$i]] != nil
        alphabetHash[phrase[$i]] += 1
        total += 1
        if alphabetHash[phrase[$i]] > max
            max = alphabetHash[phrase[$i]]
        end
    end
end

nonWords = 0

phrase.split.each { |word|
    if redis.sismember("ref:dictionary", word) == false 
                  nonWords += 1
                  puts word + " is not in the dictionary"
    end
    
}



puts alphabetHash
if alphabetHash.has_value?(0)
    puts "you have NOT used all the letters in the alphabet"
elsif nonWords > 0
    puts "you have used words absent from our english dictionary"
else
    puts "you've used all the letters in the alphabet"
    puts "you've used all valid words"
    #data = {"phrase" => phrase.capitalize, "charLength" => total, "modeChar" => max}
    redis.zadd "pangram", total, phrase
    alphabetHash.each do |letter, occurence|
        redis.hincrby("stats:alphabet", letter, occurence)
    end
end
puts "Total Alphabet chars used: " + total.to_s
puts "Max occurence of any single character: " + max.to_s


