# encoding: UTF-8

require './parlance'

vowels = "a e i o u"
vowel_clusters = "ae io au ei au ao ou ue ee ea oo oi"
consonants = "b c d f g h j k l m n p q r s t v w x y z"
consonant_clusters = "th nt ng nt st wz gh nk wh tt sh ld ry"
punctuation_marks = ". , - ? ! @ # $ % ^ & * + = ' \" \ / ( ) ; : - –"
# load text (John 1-4 ESV)
text = File.open("test.txt", "rb").read

allowed_words = "a whitelist of words can be used to ensure that vocabulary matches the pool of available terms at or in beginning"

p = Parlance.new

# initialize parser
p.vowels = vowels.split(" ")
p.vowel_clusters = vowel_clusters.split(" ")
p.consonants = consonants.split(" ")
p.consonant_clusters = consonant_clusters.split(" ")
p.text = text
p.allowed_words = allowed_words.split(" ")
p.punctuation_marks = punctuation_marks.split(" ")

# analyze text
p.process_text

# display results

# output
puts "All Words:"
puts "Word            Structure                    Count"
puts "--------------------------------------------------"
p.processed_words.each do |w, word|
	printf "%-15s %-30s %-10s\n", word[:word], word[:structure], word[:count].to_s
end

puts "\n\n"

puts "Permitted Words:"
puts "Word            Structure                    Count"
puts "--------------------------------------------------"
p.permitted_words.each do |w, word|
	printf "%-15s %-30s %-10s\n", word[:word], word[:structure], word[:count].to_s
end

puts "\n\n"

puts "Disallowed Words:"
puts "Word            Structure                    Count"
puts "--------------------------------------------------"
p.disallowed_words.each do |w, word|
	printf "%-15s %-30s %-10s\n", word[:word], word[:structure], word[:count].to_s
end

puts "\n\n"

puts "Letter   Count"
puts "--------------"
p.letters.each do |c, letter|
	printf "%-9s %s\n", letter[:letter], letter[:count].to_s
end

puts "\n\n"

puts "Vowel   Count"
puts "-------------"
p.processed_vowels.each do |v, vowel|
	printf "%-8s %s\n", vowel[:vowel], vowel[:count].to_s
end

puts "\n\n"

puts "Vowel Cluster   Count"
puts "---------------------"
p.processed_vowel_clusters.each do |vc, vowel_cluster|
	printf "%-17s %s\n", vowel_cluster[:vowel_cluster], vowel_cluster[:count].to_s
end

puts "\n\n"

puts "Consonant   Count"
puts "-----------------"
p.processed_consonants.each do |c, consonant|
	printf "%-12s %s\n", consonant[:consonant], consonant[:count].to_s
end

puts "\n\n"

puts "Consonant Cluster   Count"
puts "-------------------------"
p.processed_consonant_clusters.each do |cc, consonant_cluster|
	printf "%-20s %s\n", consonant_cluster[:consonant_cluster], consonant_cluster[:count].to_s
end

puts "\n\n"

puts "Chunk               Count"
puts "-------------------------"
p.processed_chunks.each do |c, chunk|
	printf "%-20s %s\n", chunk[:chunk], chunk[:count].to_s
end
