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
@synthesize vowelsTextField, vowelClustersTextField, consonantsTextField, consonantClustersTextField, punctuationMarksTextField, allowedWordsTextField, textTextField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    parlance = [Parlance new];
}

- (IBAction)processButtonPressed:(id)sender {
    NSLog(@"processedButtonPressed");
    
    NSString *vowelsString = [vowelsTextField stringValue];
    NSMutableArray *vowels = [NSMutableArray arrayWithArray:[vowelsString componentsSeparatedByString:@","]];
    for (int i = 0; i < vowels.count; i++) {
        NSMutableString *vowel = [NSMutableString stringWithString:[vowels objectAtIndex:i]];
        vowel = [NSMutableString stringWithString:[vowel stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [vowels setObject:vowel atIndexedSubscript:i];
    }
    [parlance setVowels:vowels];
    
    NSString *vowelClustersString = [vowelClustersTextField stringValue];
    NSMutableArray *vowelClusters = [NSMutableArray arrayWithArray:[vowelClustersString componentsSeparatedByString:@","]];
    for (int i = 0; i < vowelClusters.count; i++) {
        NSMutableString *vowelCluster = [NSMutableString stringWithString:[vowelClusters objectAtIndex:i]];
        vowelCluster = [NSMutableString stringWithString:[vowelCluster stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [vowelClusters setObject:vowelCluster atIndexedSubscript:i];
    }
    [parlance setVowelClusters:vowelClusters];
    
    NSLog(@"/processedButtonPressed");
}

@end
