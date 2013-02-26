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
    NSMutableArray *wordFragments = [wordStructure componentsSeparatedByString:@"+"];
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
