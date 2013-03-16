//
//  AppDelegate.m
//  Parlance
//
//  Created by Paul Stefan Ort on 2/24/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import "AppDelegate.h"
#import "Parlance.h"

@interface AppDelegate ()
@property (strong) Parlance *parlance;
@end

@implementation AppDelegate

@synthesize parlance;
@synthesize vowelsTextField, vowelClustersTextField, consonantsTextField, consonantClustersTextField, punctuationMarksTextField, allowedWordsTextField, textTextField, collectionView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    parlance = [Parlance new];
}

- (IBAction)processButtonPressed:(id)sender {
    NSLog(@"processedButtonPressed");
    
    NSString *vowelsString = [vowelsTextField stringValue];
    NSMutableArray *vowels = [NSMutableArray arrayWithArray:[vowelsString componentsSeparatedByString:@" "]];
    for (int i = 0; i < vowels.count; i++) {
        NSMutableString *vowel = [NSMutableString stringWithString:[vowels objectAtIndex:i]];
        vowel = [NSMutableString stringWithString:[vowel stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [vowels setObject:vowel atIndexedSubscript:i];
    }
    [parlance setVowels:vowels];
    
    NSString *vowelClustersString = [vowelClustersTextField stringValue];
    NSMutableArray *vowelClusters = [NSMutableArray arrayWithArray:[vowelClustersString componentsSeparatedByString:@" "]];
    for (int i = 0; i < vowelClusters.count; i++) {
        NSMutableString *vowelCluster = [NSMutableString stringWithString:[vowelClusters objectAtIndex:i]];
        vowelCluster = [NSMutableString stringWithString:[vowelCluster stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [vowelClusters setObject:vowelCluster atIndexedSubscript:i];
    }
    [parlance setVowelClusters:vowelClusters];

    NSString *consonantsString = [consonantsTextField stringValue];
    NSMutableArray *consonants = [NSMutableArray arrayWithArray:[consonantsString componentsSeparatedByString:@" "]];
    for (int i = 0; i < consonants.count; i++) {
        NSMutableString *consonant = [NSMutableString stringWithString:[consonants objectAtIndex:i]];
        consonant = [NSMutableString stringWithString:[consonant stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [consonants setObject:consonant atIndexedSubscript:i];
    }
    [parlance setConsonants:consonants];
    
    NSString *consonantClustersString = [consonantClustersTextField stringValue];
    NSMutableArray *consonantClusters = [NSMutableArray arrayWithArray:[consonantClustersString componentsSeparatedByString:@" "]];
    for (int i = 0; i < consonantClusters.count; i++) {
        NSMutableString *consonantCluster = [NSMutableString stringWithString:[consonantClusters objectAtIndex:i]];
        consonantCluster = [NSMutableString stringWithString:[consonantCluster stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [consonantClusters setObject:consonantCluster atIndexedSubscript:i];
    }
    [parlance setConsonantClusters:consonantClusters];
    
    NSString *punctuationMarksString = [punctuationMarksTextField stringValue];
    NSMutableArray *punctuationMarks = [NSMutableArray arrayWithArray:[punctuationMarksString componentsSeparatedByString:@" "]];
    [parlance setPunctuationMarks:punctuationMarks];
    
    NSString *allowedWordsString = [allowedWordsTextField stringValue];
    NSMutableArray *allowedWords = [NSMutableArray arrayWithArray:[allowedWordsString componentsSeparatedByString:@" "]];
    [parlance setAllowedWords:allowedWords];
    
    NSString *text = [textTextField stringValue];
    [parlance processText:text];
    
    NSLog(@"letters: %@", parlance.letters);
    NSLog(@"processedVowelClusters: %@", parlance.processedVowelClusters);
    NSLog(@"processedVowels: %@", parlance.processedVowels);
    NSLog(@"processedConsonantClusters: %@", parlance.processedConsonantClusters);
    NSLog(@"processedConsonants: %@", parlance.processedConsonants);
    NSLog(@"processedWords: %@", parlance.processedWords);
    NSLog(@"permittedWords: %@", parlance.permittedWords);
    NSLog(@"disallowedWords: %@", parlance.disallowedWords);
    
    // TODO: update collectionView
    
    NSLog(@"/processedButtonPressed");
}

@end
