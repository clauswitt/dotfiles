# TextAnalzyer is a text analyzer tool that finds out words that are
# characteristic for a given input file. It is independent from any
# language, and even seems to work well with HTML files.
#
# Author:: Martin Ankerl (mailto:martin.ankerl@gmail.com)
# Copyright:: Copyright (c) 2006, 2007 Martin Ankerl
# Date:: 2007-02-25
# License:: public domain
#
# Homepage:: http://martin.ankerl.com/2007/01/09/textanalyzer-automatically-extract-characteristic-words/

# very performance relevant code
def stream2count(io)
	count = Hash.new(0)
	size = 0
	nextLimit = 1_000_000
	while not io.eof? 
		line = io.readline
		line.downcase!

		line.scan(/\w+/) do |w|
			count[w] += 1
		end
		
		size += line.size
		if size > nextLimit
			puts "#{size} words indexed."
			nextLimit += 1_000_000
		end
	end
	
	puts "delete.."
	# remove single entries
	count.each do |key, val|
		count.delete key if val<=1
	end
	puts "del done"
	count
end


def createIndex
	File.open(".wordcount", "w") do |f|
		count = stream2count(STDIN)
		puts "saving..."
		f.write Marshal.dump(count)
		puts "done!"
	end
end

def compareIndex
	allCount = nil
	File.open(".wordcount", "r") do |f|
		puts "loading..."
		allCount = Marshal.load(f.read)
	end
	
	allWords = 0
	allCount.each do |key, val|
		allWords += val
	end
	puts "#{allWords} words loaded"

	while true
		count = nil
		puts "\nEnter Filename:"
		filename = STDIN.readline.strip
		t = Time.now		
		File.open(filename, "r") do |f|
			count = stream2count(f)
		end
		
		newt = Time.now; p newt-t; t=newt
		
		result = Array.new
		count.each do |key, val|
			result.push [key, val, allCount[key], 0]
		end
		
		newt = Time.now; p newt-t; t=newt

		# get total word count
		currWords = 0
		result.each do |key, val, all|
			currWords += val
		end
		
		# calculate score
		result.each do |r|
			r[3] = score(1.0*r[1], 1.0*currWords, 1.0*r[2], 1.0*allWords)
		end

		newt = Time.now; p newt-t; t=newt
		
		result.sort! do |a, b|
			a[3] <=> b[3]
		end
		result.reverse!
		
		newt = Time.now; p newt-t; t=newt

		count = 20
		result.each do |key, val, allVal|
			count -= 1
			break if count == 0
			printf "%5d   %5d   %1.3f   %s\n" % [val, allVal, score(1.0*val, 1.0*currWords, 1.0*allVal, 1.0*allWords), key]
			lastVal = val
		end	
		newt = Time.now; p newt-t; t=newt

	end
end

def score(curVal, curWords, allVal, allWords)
	Math.tanh(curVal/curWords*200) - 5*Math.tanh((allVal-curVal)/(allWords-curWords)*200)	
	#eval(formula)
end


if ARGV.size == 0
	puts "usage: ruby #{__FILE__} c|a
	c: create index from standard input
	a: analyze files with previously generated input"
elsif ARGV[0] == "c"
	createIndex
elsif ARGV[0] == "a"
	compareIndex
end


