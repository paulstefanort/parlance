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
@property (strong) NSArray *rawWords;

@end

@implementation Parlance

@synthesize vowels, vowelClusters, consonants, consonantClusters, text, allowedWords, punctuationMarks;

@synthesize words, letters, processedVowels, processedVowelClusters, processedConsonants, processedConsonantClusters, processedChunks, processedWords, permittedWords, disallowedWords, rawWords;

- (void)processText:(NSString *)newText {
    text = newText;
    rawWords = [text componentsSeparatedByString:@" "];
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
        
        // process vowels seocnd
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
    }
}

- (NSDictionary *)processedWords {
    
}

- (NSDictionary *)permittedWords {
    
}

- (NSDictionary *)disallowedWords {
    
}

- (NSDictionary *)processedVowels {
    
}

- (NSDictionary *)processedVowelClusters {
    
}

- (NSDictionary *)processedConsonants {
    
}

- (NSDictionary *)processedConsonantClusters {
    
}

- (NSDictionary *)letters {
    
}

- (NSDictionary *)processedChunks {
    
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
