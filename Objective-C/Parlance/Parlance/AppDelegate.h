//
//  AppDelegate.h
//  Parlance
//
//  Created by Paul Stefan Ort on 2/24/13.
//  Copyright (c) 2013 Paul Stefan Ort. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *vowelsTextField;
@property (weak) IBOutlet NSTextField *vowelClustersTextField;
@property (weak) IBOutlet NSTextField *consonantsTextField;
@property (weak) IBOutlet NSTextField *consonantClustersTextField;
@property (weak) IBOutlet NSTextField *punctuationMarksTextField;
@property (weak) IBOutlet NSTextField *allowedWordsTextField;
@property (weak) IBOutlet NSTextField *textTextField;

@end
