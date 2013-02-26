//
//  Parlance.m
//  Parlance
//
//  Created by Paul Stefan Ort on 2/24/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import "Parlance.h"

@implementation Parlance

@synthesize vowels, vowelClusters, consonants, consonantClusters, text, allowedWords, punctuationMarks;

- (void)processText:(NSString *)text {
    
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
