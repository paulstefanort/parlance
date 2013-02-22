Parlance
========

This is a tool for analyzing the properties of basic linguistic building blocks:
- vowels
- vowel clusters
- consonants
- consonant clusters

To use Parlance, specify these properties:
- vowels (array)
- vowel_clusters (array)
- consonants (array)
- consonant_clusters (array)
- punctuation_marks (array)
- allowed_words (array)
- text (string)

Calling _process_text_ prints out results including this analysis:
- composition of the words in the text (specified as combinations of vowels, vowel clusters, consonants, and consonant clusters)
- number of occurrences of each word
- number of occurrences of each allowed word
- number of occurrences of each unauthorized word.
- number of occurrences of each letter

# Sample
Run _test.rb_.
