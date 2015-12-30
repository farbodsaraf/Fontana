//
//  FNTKeyboardToolbar.m
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardToolbar.h"

@implementation FNTKeyboardToolbar
@dynamic delegate;

- (IBAction)onNextKeyboardButton:(id)sender {
    [self.delegate toolbarDidSelectNextKeyboard:sender];
}

- (IBAction)onUndo:(id)sender {
    [self.delegate toolbarDidUndo:sender];
}

@end
