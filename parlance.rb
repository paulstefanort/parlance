# encoding: UTF-8

class String
	# add starts_with?
	def starts_with?(prefix)
		prefix = prefix.to_s
		self[0, prefix.length] == prefix
	end

	def ends_with?(suffix)
		self[self.length-1] == suffix
	end
end

class Parlance
	attr_accessor :vowels, :vowel_clusters, :consonants, :consonant_clusters, :text, :words, :allowed_words, :punctuation_marks

	def process_text
		puts "Processing text."

		@words = {}
		@letters = {}
		# remove punctuation from @text
		@text = @text.gsub(Regexp.union(@punctuation_marks), "")
		# convert all words to lowercase in @text
		@text = @text.downcase
		@raw_words = @text.split(" ")
		@processed_words = {}
		@permitted_words = {}
		@disallowed_words = {}

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
			if word_structure.ends_with?("+")
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
			if word_structure.ends_with?("+")
				word_structure = word_structure[0..word_structure.length-2]
			end
			return word_structure
		end

		@raw_words.each do |raw_word|
			# process letters in raw_word
			raw_word.each_char do |c|
				if @letters.has_key?(c)
					@letter = @letters[c]
					@letter[:count] += 1
				else
					@letter = {:letter => c, :count => 1}
					@letters[c] = @letter
				end
			end

			# process raw_word
			if @processed_words.has_key?(raw_word)
				@processed_word = @processed_words[raw_word]
				@processed_word[:count] += 1
			else
				@processed_word = {:word => raw_word, :count => 1, :structure => word_structure(raw_word)}
				@processed_words[raw_word] = @processed_word
			end

			# process invalid words
			if @allowed_words.include?(raw_word)
				if @permitted_words.has_key?(raw_word)
					@permitted_word = @permitted_words[raw_word]
					@permitted_word[:count] += 1
				else
					@permitted_word = {:word => raw_word, :count => 1, :structure => word_structure(raw_word)}
					@permitted_words[raw_word] = @permitted_word
				end
			else
				if @disallowed_words.has_key?(raw_word)
					@disallowed_word = @disallowed_words[raw_word]
					@disallowed_word[:count] += 1
				else
					@disallowed_word = {:word => raw_word, :count => 1, :structure => word_structure(raw_word)}
					@disallowed_words[raw_word] = @disallowed_word
				end
			end
		end

		# sort letters in descending order of frequency
		@letters = @letters.sort_by { |c, letter| letter[:count] }.reverse

		# sort words in descending order of frequency
		@processed_words = @processed_words.sort_by { |w, word| word[:count] }.reverse
		@permitted_words = @permitted_words.sort_by { |w, word| word[:count] }.reverse
		@disallowed_words = @disallowed_words.sort_by { |w, word| word[:count] }.reverse

		# remove duplicates from allowed words
		@allowed_words = @allowed_words.uniq

		# output
		puts "All Words:"
		puts "Word            Structure                    Count"
		puts "--------------------------------------------------"
		@processed_words.each do |w, word|
			printf "%-15s %-30s %-10s\n", word[:word], word[:structure], word[:count].to_s
		end

		puts "\n\n"

		puts "Permitted Words:"
		puts "Word            Structure                    Count"
		puts "--------------------------------------------------"
		@permitted_words.each do |w, word|
			printf "%-15s %-30s %-10s\n", word[:word], word[:structure], word[:count].to_s
		end

		puts "\n\n"

		puts "Disallowed Words:"
		puts "Word            Structure                    Count"
		puts "--------------------------------------------------"
		@disallowed_words.each do |w, word|
			printf "%-15s %-30s %-10s\n", word[:word], word[:structure], word[:count].to_s
		end

		puts "\n\n"

		puts "Letter   Count"
		puts "--------------"
		@letters.each do |c, letter|
			printf "%-9s %s\n", letter[:letter], letter[:count].to_s
		end
	end
end
