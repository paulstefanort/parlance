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

	def clean_up
		# remove duplicate plus (++) signs
		new_string = self.gsub(/\++/, "+")
		if new_string.starts_with?("+")
			new_string = new_string[1..new_string.length]
		end
		if new_string.ends_with?("+")
			new_string = new_string[0..new_string.length-2]
		end
		new_string
	end
end

class Parlance
	attr_accessor :vowels, :vowel_clusters, :consonants, :consonant_clusters, :text, :words, :allowed_words, :punctuation_marks, :processed_words, :permitted_words, :disallowed_words, :processed_vowels, :processed_vowel_clusters, :processed_consonants, :processed_consonant_clusters, :letters, :processed_chunks

	def process_text
		@words = {}
		@letters = {}
		# remove punctuation from @text
		@text = @text.gsub(Regexp.union(@punctuation_marks), "")
		@text = @text.gsub(/\s+/, ' ') # remove extra spaces
		# convert all words to lowercase in @text
		@text = @text.downcase
		@raw_words = @text.split(" ")
		@processed_words = {}
		@permitted_words = {}
		@disallowed_words = {}
		@processed_vowels = {}
		@processed_vowel_clusters = {}
		@processed_consonants = {}
		@processed_consonant_clusters = {}
		@processed_chunks = {} 

		def word_structure(word)
			word_structure = word
			# go through vowel clusters
			@vowel_clusters.each do |vowel_cluster|
				word_structure = word_structure.gsub(vowel_cluster, "+" + vowel_cluster + "+")
			end
			# go through consonant clusters
			@consonant_clusters.each do |consonant_cluster|
				word_structure = word_structure.gsub(consonant_cluster, "+" + consonant_cluster + "+")
			end
			word_structure = word_structure.clean_up

			# loop through word fragments evaluated from vowel clusters and consonant clusters
			word_fragments = word_structure.split("+")
			word_fragments.each_index do |index|
				word_fragment = word_fragments[index]
				# skip if it matches a vowel cluster
				if @vowel_clusters.include?(word_fragment)
					next # proceed to next fragment
				end
				# skip if it matches a consonant cluster
				if @consonant_clusters.include?(word_fragment)
					next # proceed to text fragment
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
			word_structure = word_structure.clean_up
			word_structure
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

			processed_word_structure = word_structure(raw_word)
			original_processed_word_structure = processed_word_structure

			# process vowel_clusters first
			@vowel_clusters.each do |vowel_cluster|
				if processed_word_structure.include?(vowel_cluster)
					if @processed_vowel_clusters.has_key?(vowel_cluster)
						@processed_vowel_cluster = @processed_vowel_clusters[vowel_cluster]
						@processed_vowel_cluster[:count] += processed_word_structure.count(vowel_cluster)
					else
						@processed_vowel_cluster = {:vowel_cluster => vowel_cluster, :count => processed_word_structure.count(vowel_cluster)}
						@processed_vowel_clusters[vowel_cluster] =  @processed_vowel_cluster
					end
					# remove the counted vowel_cluster, preventing its characters from counting as vowels also
					processed_word_structure = processed_word_structure.gsub(vowel_cluster, '')
				end
			end

			# process vowels second
			@vowels.each do |vowel|
				if processed_word_structure.include?(vowel)
					if @processed_vowels.has_key?(vowel)
						@processed_vowel = @processed_vowels[vowel]
						@processed_vowel[:count] += processed_word_structure.count(vowel)
					else
						@processed_vowel = {:vowel => vowel, :count => processed_word_structure.count(vowel)}
						@processed_vowels[vowel] = @processed_vowel
					end
					# remove the counted vowel
					processed_word_structure = processed_word_structure.gsub(vowel, '')
				end
			end

			# process consonant_clusters third
			@consonant_clusters.each do |consonant_cluster|
				if processed_word_structure.include?(consonant_cluster)
					if @processed_consonant_clusters.has_key?(consonant_cluster)
						@processed_consonant_cluster = @processed_consonant_clusters[consonant_cluster]
						@processed_consonant_cluster[:count] += processed_word_structure.count(consonant_cluster)
					else
						@processed_consonant_cluster = {:consonant_cluster => consonant_cluster, :count => processed_word_structure.count(consonant_cluster)}
						@processed_consonant_clusters[consonant_cluster] = @processed_consonant_cluster
					end
					# remove the counted consonant_cluster, preventing its characters from counting as consonants also
					processed_word_structure = processed_word_structure.gsub(consonant_cluster, '')
				end
			end

			# process consonants fourth
			@consonants.each do |consonant|
				if processed_word_structure.include?(consonant)
					if @processed_consonants.has_key?(consonant)
						@processed_consonant = @processed_consonants[consonant]
						@processed_consonant[:count] += processed_word_structure.count(consonant)
					else
						@processed_consonant = {:consonant => consonant, :count => processed_word_structure.count(consonant)}
						@processed_consonants[consonant]= @processed_consonant
					end
					# remove the counted consonant
					processed_word_structure = processed_word_structure.gsub(consonant, '')
				end
			end

			# generate word counts
			if @processed_words.has_key?(raw_word)
				@processed_word = @processed_words[raw_word]
				@processed_word[:count] += 1
			else
				@processed_word = {:word => raw_word, :count => 1, :structure => original_processed_word_structure}
				@processed_words[raw_word] = @processed_word
			end

			# process allowed and disallowed words
			if @allowed_words.include?(raw_word)
				if @permitted_words.has_key?(raw_word)
					@permitted_word = @permitted_words[raw_word]
					@permitted_word[:count] += 1
				else
					@permitted_word = {:word => raw_word, :count => 1, :structure => original_processed_word_structure}
					@permitted_words[raw_word] = @permitted_word
				end
			else
				if @disallowed_words.has_key?(raw_word)
					@disallowed_word = @disallowed_words[raw_word]
					@disallowed_word[:count] += 1
				else
					@disallowed_word = {:word => raw_word, :count => 1, :structure => original_processed_word_structure}
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

		# sort vowels in descending order of frequency
		@processed_vowels = @processed_vowels.sort_by { |v, vowel| vowel[:count] }.reverse

		# sort vowel clusters in descending order of frequency
		@processed_vowel_clusters = @processed_vowel_clusters.sort_by { |vc, vowel_cluster| vowel_cluster[:count] }.reverse

		# sort consonantsin descending order of frequency
		@processed_consonants = @processed_consonants.sort_by { |c, consonant| consonant[:count] }.reverse

		# sort consonant clusters in descending order of frequency
		@processed_consonant_clusters = @processed_consonant_clusters.sort_by { |cc, consonant_cluster| consonant_cluster[:count] }.reverse

		# build master list of fragments
		@processed_vowels.each do |v, vowel|
			@processed_chunk = {:chunk => vowel[:vowel], :count => vowel[:count]}
			@processed_chunks[vowel] = @processed_chunk
		end

		@processed_vowel_clusters.each do |vc, vowel_cluster|
			@processed_chunk = {:chunk => vowel_cluster[:vowel_cluster], :count => vowel_cluster[:count]}
			@processed_chunks[vowel_cluster] = @processed_chunk
		end

		@processed_consonants.each do |c, consonant|
			@processed_chunk = {:chunk => consonant[:consonant], :count => consonant[:count]}
			@processed_chunks[consonant] = @processed_chunk
		end

		@processed_consonant_clusters.each do |cc, consonant_cluster|
			@processed_chunk = {:chunk => consonant_cluster[:consonant_cluster], :count => consonant_cluster[:count]}
			@processed_chunks[consonant_cluster] = @processed_chunk
		end

		# sort processed chunks in descending order of frequency
		@processed_chunks = @processed_chunks.sort_by { |c, chunk| chunk[:count] }.reverse

		# remove duplicates from allowed words
		@allowed_words = @allowed_words.uniq

	end
end
