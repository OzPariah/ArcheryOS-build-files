#!/usr/bin/env ruby

#
# This script takes a list of twitter usernames or search terms and generates a
# word list based on them. For usernames it requests the last 500 tweets from
# that user, for a search term it requests 500 tweets including that term.
#
# The script is based on an original idea from the
# "7 Habits of Highly Effective Hackers" blog
# http://7habitsofhighlyeffectivehackers.blogspot.com.au/2012/05/using-twitter-to-build-password.html
#
# Author:: Robin Wood (robin@digininja.org)
# Copyright:: Copyright (c) Robin Wood 2012
# Licence:: Creative Commons Attribution-Share Alike 2.0
#

require 'rubygems'
require 'json'
require 'net/http'
require 'getoptlong'

opts = GetoptLong.new(
	[ '--help', '-h', GetoptLong::NO_ARGUMENT ],
	[ '--count', '-c', GetoptLong::NO_ARGUMENT ],
	[ '--min_word_length', "-m" , GetoptLong::REQUIRED_ARGUMENT ],
	[ '--term_file', "-T" , GetoptLong::REQUIRED_ARGUMENT ],
	[ '--terms', "-t" , GetoptLong::REQUIRED_ARGUMENT ],
	[ '--user_file', "-U" , GetoptLong::REQUIRED_ARGUMENT ],
	[ '--users', "-u" , GetoptLong::REQUIRED_ARGUMENT ],
	[ '--verbose', "-v" , GetoptLong::NO_ARGUMENT ]
)

def usage
	puts 'twofi 1.0 Robin Wood (robin@digininja.org) (www.digininja.org)
twofi - Twitter Words Of Interest

Usage: twofi [OPTIONS]
	--help, -h: show help
	--count, -c: include the count with the words
	--min_word_length, -m: minimum word length
	--term_file, -T file: a file containing a list of terms
	--terms, -t: comma separated usernames
		quote words containing spaces, no space after commas
	--user_file, -U file: a file containing a list of users
	--users, -u: comma separated search terms
		quote words containing spaces, no space after commas
	--verbose, -v: verbose

'
	exit
end

def twitter_search(query, results=500)
   url = "http://search.twitter.com/search.json?q=" + URI.encode(query) + "&rpp=" + results.to_s
   resp = Net::HTTP.get_response(URI.parse(url))
   data = resp.body

   # Should probably do some error handling here but not really sure
   # what errors could come back
   result = JSON.parse(data)

   return result
end

users=[]
terms=[]
min_word_length=3
show_count=false

begin
	opts.each do |opt, arg|
		case opt
		when '--count'
			show_count = true
		when '--help'
			usage
		when "--user_file"
			begin
				File.new(arg, 'r').each_line do |line|
					username = 'from:' + line.chomp.sub(/^@/, '')
					terms << username
				end
			rescue
				puts "Unable to read the users file\n"
				exit
			end
		when "--term_file"
			begin
				File.new(arg, 'r').each_line do |line|
					terms << line.chomp
				end
			rescue
				puts "Unable to read the terms file\n"
				exit
			end
		when '--terms'
			arg.split(',').each do |term|
				terms << term
			end
		when '--users'
			arg.split(',').each do |user|
				username = 'from:' + user.chomp.sub(/^@/, '')
				terms << username
			end
		when '--min_word_length'
			min_word_length=arg.to_i
			if min_word_length<1
				usage
			end
		when '--verbose'
			verbose=true
		when '--write'
			outfile=arg
		end
	end
rescue => e
	usage
end

if terms.count == 0
	puts 'You must specify at least one search term or username'
	puts
	usage
end

results = []

#puts terms.inspect
terms.each do |term|
	data = twitter_search(term, 500)
	results += data['results']
end

if results.count == 0
	puts "No search results"
else
	wordlist = {}
	results.each do |result|
		text = result['text']
		# Strip any non word type characters
		text.gsub!(/[^\w \s \d]/, ' ')
		words = text.split(/\s/)
		words.each do |word|
			#Empty or shorter than required
			if word == '' or word.length < min_word_length
				next
			end
			if wordlist.key?(word)
				wordlist[word] += 1
			else
				wordlist[word] = 1
			end
		end
	end

	sorted_wordlist = wordlist.sort_by do |word, count| -count end
	sorted_wordlist.each do |word, count|
		if show_count
			puts word + ', ' + count.to_s
		else
			puts word
		end
	end
end
