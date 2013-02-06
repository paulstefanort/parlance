class String
	# add starts_with?
	def starts_with?(prefix)
		prefix = prefix.to_s
		self[0, prefix.length] == prefix
	end
end

class Parlance
	attr_accessor :vowels, :vowel_clusters, :consonants, :consonant_clusters, :text, :words

	def process_text
		puts "Processing text."

		@words = {}
		# remove punctuation from @text
		punctuation = ["\\.", "\\-", "\\?", "\\!", "\\@", "[']", '\\"', "\\,", "\\(", "\\)", "\\;", "\\:"]
		punctuation_regex = Regexp.new(punctuation.map{ |s| "(#{s})" }.join("|"))
		@text = @text.gsub(punctuation_regex, "")
		# convert all words to lowercase in @text
		@text = @text.downcase
		@raw_words = @text.split(" ")
		@processed_words = {}

		def word_structure(word)
			word_structure = word
			# go through vowels
			@vowel_clusters.each do |vowel_cluster|
				word_structure = word_structure.gsub(vowel_cluster, "+" + vowel_cluster + "+")
			end
			# go through consonants
			@consonant_clusters.each do |consonant_cluster|
				word_structure = word_structure.gsub(consonant_cluster, "+" + consonant_cluster + "+")
			end
			# remove duplicate plus (++) signs
			word_structure = word_structure.gsub(/\++/, "+")
			# remove leading and trailing plus (+) signs
			if word_structure.starts_with?("+")
				word_structure = word_structure[1..word_structure.length]
			end
			if word_structure[word_structure.length-1] == "+"
				word_structure = word_structure[0..word_structure.length-2]
			end

			word_fragments = word_structure.split("+")
			word_fragments.each_index do |index|
				word_fragment = word_fragments[index]
				# skip if it matches a vowel cluster
				if @vowel_clusters.include?(word_fragment)
					break
				end
				# skip if it matches a consonant cluster
				if @consonant_clusters.include?(word_fragment)
					break
				end
				# otherwise break it up into vowels
				@vowels.each do |vowel|
					word_fragment = word_fragment.gsub(vowel, "+" + vowel + "+")
				end
				# and consonants
				@consonants.each do |consonant|
					word_fragment = word_fragment.gsub(consonant, "+" + consonant + "+")
				end
				word_fragments[index] = word_fragment
			end
			word_structure = word_fragments.join("+")
			# remove duplicate plus (++) signs
			word_structure = word_structure.gsub(/\++/, "+")
			# remove leading and trailing plus (+) signs
			if word_structure.starts_with?("+")
				word_structure = word_structure[1..word_structure.length]
			end
			if word_structure[word_structure.length-1] == "+"
				word_structure = word_structure[0..word_structure.length-2]
			end
			return word_structure
		end

		@raw_words.each do |raw_word|
			# process raw_word
			if @processed_words.has_key?(raw_word)
				@processed_word = @processed_words[raw_word]
				@processed_word[:count] += 1
			else
				@processed_word = {:word => raw_word, :count => 1, :structure => word_structure(raw_word)}
				@processed_words[raw_word] = @processed_word
			end
		end

		# sort words in descending order of frequency
		@processed_words = @processed_words.sort_by { |w, word| word[:count] }.reverse

		# output
		puts "Word        |      Count"
		puts "------------------------"
		@processed_words.each do |w, word|
			printf "%-20s %s\n", word[:word], word[:count].to_s
#			puts word[:word] + "           " + word[:count].to_s
			#puts processed_word[:word].to_s + "          " + processed_word[:count].to_s
		end
	end
end
