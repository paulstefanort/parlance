//
//  NSString+Parlance.m
//  Parlance
//
//  Created by Paul Stefan Ort on 2/25/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import "NSString+Parlance.h"

@implementation NSString (Parlance)

- (bool)containsString:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return range.location != NSNotFound;
}

- (NSString *)cleanup {
    NSMutableString *newString = [NSMutableString stringWithFormat:@"%@", self];
    // replace ++ with +
    while ([newString containsString:@"++"]) {
        newString = [NSMutableString stringWithFormat:@"%@", [newString stringByReplacingOccurrencesOfString:@"++" withString:@"+"]];
    }
    if ([newString hasPrefix:@"+"]) {
        newString = [NSMutableString stringWithFormat:@"%@", [newString substringFromIndex:1]];
    }
    if ([newString hasSuffix:@"+"]) {
        newString = [NSMutableString stringWithFormat:@"%@", [newString substringToIndex:[newString length] - 2]];
    }
    return newString;
}

@end
