require './parlance'

vowels = "a e i o u"
vowel_clusters = "ae io au ei au ao ou ue ee ea"
consonants = "b c d f g h j k l m n p q r s t v w x y z"
consonant_clusters = "th nt ng nt st wz gh nk wh tt sh ld ry"
# load text (John 1-4 ESV)
text = File.open("test.txt", "rb").read

p = Parlance.new

# initialize parser
p.vowels = vowels.split(" ")
p.vowel_clusters = vowel_clusters.split(" ")
p.consonants = consonants.split(" ")
p.consonant_clusters = consonant_clusters.split(" ")
p.text = text

# analyze text
p.process_text
