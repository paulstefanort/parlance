//
//  Parlance.m
//  Parlance
//
//  Created by Paul Stefan Ort on 2/24/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import "Parlance.h"

@interface Parlance ()

@property (strong) NSMutableDictionary *words;
@property (strong) NSMutableDictionary *letters;
@property (strong) NSMutableDictionary *processedVowels;
@property (strong) NSMutableDictionary *processedVowelClusters;
@property (strong) NSMutableDictionary *processedConsonants;
@property (strong) NSMutableDictionary *processedConsonantClusters;
@property (strong) NSMutableDictionary *processedChunks;
@property (strong) NSMutableDictionary *processedWords;
@property (strong) NSMutableDictionary *permittedWords;
@property (strong) NSMutableDictionary *disallowedWords;
@property (strong) NSMutableArray *rawWords;

@end

@implementation Parlance

@synthesize vowels, vowelClusters, consonants, consonantClusters, text, allowedWords, punctuationMarks;

@synthesize words, letters, processedVowels, processedVowelClusters, processedConsonants, processedConsonantClusters, processedChunks, processedWords, permittedWords, disallowedWords, rawWords;

- (void)processText:(NSString *)newText {
    text = newText;
    for (NSString *punctuationMark in punctuationMarks) {
        text = [text stringByReplacingOccurrencesOfString:punctuationMark withString:@""];
    }
    rawWords = [NSMutableArray arrayWithArray:[text componentsSeparatedByString:@" "]];
    for (int i = 0; i < rawWords.count; i++) {
        NSString *rawWord = [rawWords objectAtIndex:i];
        rawWord = [rawWord lowercaseString];
        for (NSString *punctuationMark in punctuationMarks) {
            rawWord = [rawWord stringByReplacingOccurrencesOfString:punctuationMark withString:@""];
        }
        [rawWords setObject:rawWord atIndexedSubscript:i];
    }
    processedWords = [NSMutableDictionary new];
    permittedWords = [NSMutableDictionary new];
    disallowedWords = [NSMutableDictionary new];
    processedVowels = [NSMutableDictionary new];
    processedVowelClusters = [NSMutableDictionary new];
    processedConsonants = [NSMutableDictionary new];
    processedConsonantClusters = [NSMutableDictionary new];
    processedChunks = [NSMutableDictionary new];
    
    for (NSString *rawWord in rawWords) {
        // process letters in rawWord
        for (int i = 0; i < rawWord.length; i++) {
            NSString *character = [rawWord substringWithRange:NSMakeRange(i, 1)];
            if ([letters objectForKey:character]) {
                // increase letter count
                NSMutableDictionary *letter = [letters objectForKey:character];
                NSNumber *letterCount = [letter objectForKey:@"count"];
                [letter setObject:[NSNumber numberWithInt:[letterCount intValue] + 1] forKey:@"count"];
                [letters setObject:letter forKey:character];
            } else {
                // record first instance of letter
                NSMutableDictionary *letter = [NSMutableDictionary dictionaryWithDictionary:@{@"letter": character, @"count": @1}];
                [letters setObject:letter forKey:character];
            }
        }
        
        NSString *processedWordStructure = [self structureForWord:rawWord];
        NSString *originalProcessedWordStructure = [NSString stringWithFormat:@"%@", processedWordStructure];
        
        // process vowel clusters first
        for (NSString *vowelCluster in vowelClusters) {
            if ([processedWordStructure containsString:vowelCluster]) {
                if ([processedVowelClusters objectForKey:vowelCluster]) {
                    // increase vowel cluster count
                    NSMutableDictionary *processedVowelCluster = [processedVowelClusters objectForKey:vowelCluster];
                    NSNumber *vowelClusterCount = [processedVowelCluster objectForKey:@"count"];
                    [processedVowelCluster setObject:[NSNumber numberWithInt:[vowelClusterCount intValue] + 1] forKey:@"count"];
                    [processedVowelClusters setObject:processedVowelCluster forKey:vowelCluster];
                } else {
                    // record first instance of vowel cluster
                    NSMutableDictionary *processedVowelCluster = [NSMutableDictionary dictionaryWithDictionary:@{@"vowelCluster": vowelCluster, @"count": @1}];
                    [processedVowelClusters setObject:processedVowelCluster forKey:vowelCluster];
                }
            }
        }
        
        // process vowels second
        for (NSString *vowel in vowels) {
            if ([processedWordStructure containsString:vowel]) {
                if ([processedVowels objectForKey:vowel]) {
                    // increase vowel count
                    NSMutableDictionary *processedVowel = [processedVowels objectForKey:vowel];
                    NSNumber *vowelCount = [processedVowel objectForKey:@"count"];
                    [processedVowel setObject:[NSNumber numberWithInt:[vowelCount intValue] + 1] forKey:@"count"];
                    [processedVowels setObject:processedVowel forKey:vowel];
                } else {
                    // record first instance of vowel
                    NSMutableDictionary *processedVowel = [NSMutableDictionary dictionaryWithDictionary:@{@"vowel": vowel, @"count": @1}];
                    [processedVowels setObject:processedVowel forKey:processedVowel];
                }
            }
        }
        
        // process consonant clusters third
        for (NSString *consonantCluster in consonantClusters) {
            if ([processedWordStructure containsString:consonantCluster]) {
                if ([processedConsonantClusters objectForKey:consonantCluster]) {
                    // increase consonant cluster count
                    NSMutableDictionary *processedConsonantCluster = [processedConsonantClusters objectForKey:consonantCluster];
                    NSNumber *consonantClusterCount = [processedConsonantCluster objectForKey:@"count"];
                    [processedConsonantCluster setObject:[NSNumber numberWithInt:[consonantClusterCount intValue] + 1] forKey:@"count"];
                    [processedConsonantClusters setObject:processedConsonantCluster forKey:consonantCluster];
                } else {
                    // record first instance of consonant cluster
                    NSMutableDictionary *processedConsonantCluster = [NSMutableDictionary dictionaryWithDictionary:@{@"consonantCluster": consonantCluster, @"count": @1}];
                    [processedConsonantClusters setObject:processedConsonantCluster forKey:consonantCluster];
                }
            }
        }
        
        // process consonants fourth
        for (NSString *consonant in consonants) {
            if ([processedWordStructure containsString:consonant]) {
                if ([processedConsonants objectForKey:consonant]) {
                    // increase consonant count
                    NSMutableDictionary *processedConsonant = [processedConsonants objectForKey:consonant];
                    NSNumber *consonantCount = [processedConsonant objectForKey:@"count"];
                    [processedConsonant setObject:[NSNumber numberWithInt:[consonantCount intValue] + 1] forKey:@"count"];
                    [processedConsonants setObject:processedConsonant forKey:consonant];
                } else {
                    // record first instance of consonant
                    NSMutableDictionary *processedConsonant = [NSMutableDictionary dictionaryWithDictionary:@{@"consonant": consonant, @"count": @1}];
                    [processedConsonants setObject:processedConsonant forKey:consonant];
                }
            }
        }
        
        // process word counts
        if ([processedWords objectForKey:rawWord]) {
            // increase word count
            NSMutableDictionary *processedWord = [processedWords objectForKey:rawWord];
            NSNumber *processedWordCount = [processedWord objectForKey:@"count"];
            [processedWord setObject:[NSNumber numberWithInt:[processedWordCount intValue] + 1] forKey:rawWord];
            [processedWords setObject:processedWord forKey:rawWord];
        } else {
            // record first instance of word
            NSMutableDictionary *processedWord = [NSMutableDictionary dictionaryWithDictionary:@{@"word": rawWord, @"count": @1, @"structure": originalProcessedWordStructure}];
            [processedWords setObject:processedWord forKey:rawWord];
        }
        
        // process allowed and disallowed words
        if ([allowedWords containsObject:rawWord]) {
            if ([permittedWords objectForKey:rawWord]) {
                // increase permitted word count
                NSMutableDictionary *permittedWord = [permittedWords objectForKey:rawWord];
                NSNumber *permittedWordCount = [permittedWord objectForKey:@"count"];
                [permittedWord setObject:[NSNumber numberWithInt:[permittedWordCount intValue] + 1] forKey:@"count"];
                [permittedWords setObject:permittedWord forKey:rawWord];
            } else {
                // record first instance of permitted word
                NSMutableDictionary *permittedWord = [NSMutableDictionary dictionaryWithDictionary:@{@"word": rawWord, @"count": @1, @"structure": originalProcessedWordStructure}];
                [permittedWords setObject:permittedWord forKey:rawWord];
            }
        } else {
            if ([disallowedWords objectForKey:rawWord]) {
                // increase disallowed word count
                NSMutableDictionary *disallowedWord = [disallowedWords objectForKey:rawWord];
                NSNumber *disallowedWordCount = [disallowedWord objectForKey:@"count"];
                [disallowedWord setObject:[NSNumber numberWithInt:[disallowedWordCount intValue] + 1] forKey:@"count"];
                [disallowedWords setObject:disallowedWord forKey:rawWord];
            } else {
                // record first instance of disallowed word
                NSMutableDictionary *disallowedWord = [NSMutableDictionary dictionaryWithDictionary:@{@"word": rawWord, @"count": @1, @"structure": originalProcessedWordStructure}];
                [disallowedWords setObject:disallowedWord forKey:rawWord];
            }
        }
    }
    
    // sort letters in descending order of frequency
    NSArray *sortedLetters = [[letters allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    letters = [NSMutableDictionary new];
    NSEnumerator *lettersEnumerator = [sortedLetters reverseObjectEnumerator];
    for (NSDictionary *letter in lettersEnumerator) {
        [letters setObject:letter forKey:[letter objectForKey:@"letter"]];
    }
    
    // sort words in descending order of frequency
    NSArray *sortedProcessedWords = [[processedWords allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    processedWords = [NSMutableDictionary new];
    NSEnumerator *processedWordsEnumerator = [sortedProcessedWords reverseObjectEnumerator];
    for (NSDictionary *processedWord in processedWordsEnumerator) {
        [processedWords setObject:processedWord forKey:[processedWord objectForKey:@"word"]];
    }
    
    NSArray *sortedPermittedWords = [[permittedWords allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    permittedWords = [NSMutableDictionary new];
    NSEnumerator *permittedWordsEnumerator = [sortedPermittedWords reverseObjectEnumerator];
    for (NSDictionary *permittedWord in permittedWordsEnumerator) {
        [permittedWords setObject:permittedWord forKey:[permittedWord objectForKey:@"word"]];
    }
    
    NSArray *sortedDisallowedWords = [[disallowedWords allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    disallowedWords = [NSMutableDictionary new];
    NSEnumerator *disallowedWordsEnumerator = [sortedDisallowedWords reverseObjectEnumerator];
    for (NSDictionary *disallowedWord in disallowedWordsEnumerator) {
        [disallowedWords setObject:disallowedWord forKey:[disallowedWord objectForKey:@"word"]];
    }
    
    // sort vowels in descending order of frequency
    NSArray *sortedProcessedVowels = [[processedVowels allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    processedVowels = [NSMutableDictionary new];
    NSEnumerator *processedVowelsEnumerator = [sortedProcessedVowels reverseObjectEnumerator];
    for (NSDictionary *processedVowel in processedVowelsEnumerator) {
        [processedVowels setObject:processedVowel forKey:[processedVowel objectForKey:@"vowel"]];
    }
    
    // sort vowel clusters in descending order of frequency
    NSArray *sortedProcessedVowelClusters = [[processedVowelClusters allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    processedVowelClusters = [NSMutableDictionary new];
    NSEnumerator *processedVowelClustersEnumerator = [sortedProcessedVowelClusters reverseObjectEnumerator];
    for (NSDictionary *processedVowelCluster in processedVowelClustersEnumerator) {
        [processedVowelClusters setObject:processedVowelCluster forKey:[processedVowelCluster objectForKey:@"vowelCluster"]];
    }
    
    // sort consonants in descending order of frequency
    NSArray *sortedProcessedConsonants = [[processedConsonants allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [a objectForKey:@"count"];
        return [first compare:second];
    }];
    processedConsonants = [NSMutableDictionary new];
    NSEnumerator *processedConsonantsEnumerator = [sortedProcessedConsonants reverseObjectEnumerator];
    for (NSDictionary *processedConsonant in processedConsonantsEnumerator) {
        [processedConsonants setObject:processedConsonant forKey:[processedConsonant objectForKey:@"consonant"]];
    }
    
    // sort consonant clusters in descending order of frequency
    NSArray *sortedProcessedConsonantClusters = [[processedConsonantClusters allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    processedConsonantClusters = [NSMutableDictionary new];
    NSEnumerator *processedConsonantClusterEnumerator = [sortedProcessedConsonantClusters reverseObjectEnumerator];
    for (NSDictionary *processedConsonantCluster in processedConsonantClusterEnumerator) {
        [processedConsonantClusters setObject:processedConsonantCluster forKey:[processedConsonantCluster objectForKey:@"consonantCluster"]];
    }
    
    // build master list of fragments
    // vowels
    for (id key in processedVowels) {
        NSDictionary *processedVowel = [processedVowels objectForKey:key];
        NSString *vowel = [processedVowel objectForKey:@"vowel"];
        NSNumber *count = [processedVowel objectForKey:@"count"];
        NSDictionary *processedChunk = @{@"chunk": vowel, @"count": count};
        [processedChunks setObject:processedChunk forKey:vowel];
    }
    // vowel clusters
    for (id key in processedVowelClusters) {
        NSDictionary *processedVowelCluster = [processedVowelClusters objectForKey:key];
        NSString *vowelCluster = [processedVowelCluster objectForKey:@"vowelCluster"];
        NSNumber *count = [processedVowelCluster objectForKey:@"count"];
        NSDictionary *processedChunk = @{@"chunk": vowelCluster, @"count": count};
        [processedChunks setObject:processedChunk forKey:vowelCluster];
    }
    // consonants
    for (id key in processedConsonants) {
        NSDictionary *processedConsonant = [processedConsonants objectForKey:key];
        NSString *consonant = [processedConsonant objectForKey:@"consonant"];
        NSNumber *count = [processedConsonant objectForKey:@"count"];
        NSDictionary *processedChunk = @{@"chunk": consonant, @"count": count};
        [processedChunks setObject:processedChunk forKey:consonant];
    }
    // consonant clusters
    for (id key in processedConsonantClusters) {
        NSDictionary *processedConsonantCluster = [processedConsonantClusters objectForKey:key];
        NSString *consonantCluster = [processedConsonantCluster objectForKey:@"consonantCluster"];
        NSNumber *count = [processedConsonantCluster objectForKey:@"count"];
        NSDictionary *processedChunk = @{@"chunk": consonantCluster, @"count": count};
        [processedChunks setObject:processedChunk forKey:consonantCluster];
    }
    
    // sort processed chunks in descending order of frequency
    NSArray *sortedProcessedChunks = [[processedChunks allValues] sortedArrayUsingComparator:^(NSDictionary *a, NSDictionary *b) {
        NSNumber *first = [a objectForKey:@"count"];
        NSNumber *second = [b objectForKey:@"count"];
        return [first compare:second];
    }];
    processedChunks = [NSMutableDictionary new];
    NSEnumerator *processedChunksEnumerator = [sortedProcessedChunks reverseObjectEnumerator];
    for (NSDictionary *processedChunk in processedChunksEnumerator) {
        [processedChunks setObject:processedChunk forKey:[processedChunk objectForKey:@"chunk"]];
    }
    
    // remove duplicates from allowed words
    allowedWords = [[NSSet setWithArray:allowedWords] allObjects];
}

- (NSString *)structureForWord:(NSString *)word {
    NSString *wordStructure = word;
    // process vowel clusters
    for (NSString *vowelCluster in vowelClusters) {
        wordStructure = [wordStructure stringByReplacingOccurrencesOfString:vowelCluster withString:[NSString stringWithFormat:@"+%@+", vowelCluster]];
    }
    // process consonant clusters
    for (NSString *consonantCluster in consonantClusters) {
        wordStructure = [wordStructure stringByReplacingOccurrencesOfString:consonantCluster withString:[NSString stringWithFormat:@"+%@+", consonantCluster]];
    }
    wordStructure = [wordStructure cleanup];
    
    // loop through fragments
    NSMutableArray *wordFragments = [NSMutableArray arrayWithArray:[wordStructure componentsSeparatedByString:@"+"]];
    for (int i = 0; i < wordFragments.count; i++) {
        NSString *wordFragment = [wordFragments objectAtIndex:i];
        // skip if fragment matches vowel cluster
        if ([vowelClusters containsObject:wordFragment]) {
            break;
        }
        // skip if fragment matches consonant cluster
        if ([consonantClusters containsObject:wordFragment]) {
            break;
        }
        // otherwise divide fragment into vowels
        for (NSString *vowel in vowels) {
            wordFragment = [wordFragment stringByReplacingOccurrencesOfString:vowel withString:[NSString stringWithFormat:@"+%@+", vowel]];
        }
        // and consonants
        for (NSString *consonant in consonants) {
            wordFragment = [wordFragment stringByReplacingOccurrencesOfString:consonant withString:[NSString stringWithFormat:@"+%@+", consonant]];
        }
        [wordFragments replaceObjectAtIndex:i withObject:wordFragment];
    }
    wordStructure = [wordFragments componentsJoinedByString:@"+"];
    wordStructure = [wordStructure cleanup];
    return wordStructure;
}

@end
