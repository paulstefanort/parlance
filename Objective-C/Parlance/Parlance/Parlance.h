//
//  Parlance.h
//  Parlance
//
//  Created by Paul Stefan Ort on 2/24/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Parlance.h"

@interface Parlance : NSObject

@property (strong) NSArray *vowels;
@property (strong) NSArray *vowelClusters;
@property (strong) NSArray *consonants;
@property (strong) NSArray *consonantClusters;
@property (strong) NSString *text;
@property (strong) NSArray *allowedWords;
@property (strong) NSArray *punctuationMarks;

- (void)processText:(NSString *)text;

- (NSDictionary *)processedWords;
- (NSDictionary *)permittedWords;
- (NSDictionary *)disallowedWords;
- (NSDictionary *)processedVowels;
- (NSDictionary *)processedVowelClusters;
- (NSDictionary *)processedConsonants;
- (NSDictionary *)processedConsonantClusters;
- (NSDictionary *)letters;
- (NSDictionary *)processedChunks;

@end
