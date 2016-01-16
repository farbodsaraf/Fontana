//
//  FNTFakeKeyboardProxy.m
//  Spreadit
//
//  Created by Marko Hlebar on 31/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTFakeKeyboardProxy.h"

@implementation FNTFakeKeyboardProxy

- (instancetype)init {
    self = [super init];
    if (self) {
        _pointerLocation = 0;
    }
    return self;
}

- (BOOL)hasText {
    return self.text.length > 0;
}

- (NSMutableString *)text {
    if (!_text) {
        _text = [NSMutableString new];
    }
    return _text;
}

- (void)insertText:(NSString *)text {
    [self.text appendString:text];
    [self updatePointerLocationToLength];
}

- (void)deleteBackward {
    if (!self.hasText) {
        return;
    }
    [self.text deleteCharactersInRange:NSMakeRange(self.text.length - 1, 1)];
    [self updatePointerLocationToLength];
}

- (void)updatePointerLocationToLength {
    self.pointerLocation = self.text.length;
}

- (void)adjustTextPositionByCharacterOffset:(NSInteger)offset {
    self.pointerLocation += offset;
    self.pointerLocation = self.pointerLocation >= 0 ? self.pointerLocation : 0;
}

- (NSString *)documentContextBeforeInput {
    return [self.text substringToIndex:self.pointerLocation];
}

- (NSString *)documentContextAfterInput {
    return [self.text substringFromIndex:self.pointerLocation];
}

@end
