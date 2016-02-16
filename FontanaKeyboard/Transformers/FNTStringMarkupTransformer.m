//
//  FNTStringMarkupTransformer.m
//  Spreadit
//
//  Created by Marko Hlebar on 16/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTStringMarkupTransformer.h"
#import "NSString+FNTAccessors.h"


static NSString *const kMarkupString = @":";
static NSUInteger kMaxWordCount = 5;

@implementation FNTStringMarkupTransformer

- (id)transformedValue:(NSString *)string {
    if (![self isTransformable:string]) {
        return string;
    }
    
    NSString *transformedString = string;
    transformedString = [transformedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    transformedString = [transformedString stringByTrimmingCharactersInSet:[self trimmingCharacterSet]];
    transformedString = [transformedString stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@":"];
    transformedString = [transformedString stringByAppendingString:@":"];
    return transformedString;
}

- (BOOL)isSentence:(NSString *)string {
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //If sentence starts and ends with : it's not a sentence
    if ([[trimmedString substringToIndex:1] isEqualToString:kMarkupString] &&
        [[trimmedString substringWithRange:NSMakeRange(trimmedString.length - 2, 1)] isEqualToString:kMarkupString]) {
        return NO;
    }
    
    //If it contains markup anywhere in the middle of the sentence it's a sentence
    if ([self contextHasMarkup:trimmedString]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isTransformable:(NSString *)string {
    return ![self isSentence:string] && string.fnt_wordCount <= kMaxWordCount;
}

- (BOOL)contextHasMarkup:(NSString *)context {
    //:word: produces [@"", @"word", @""]
    NSArray *words = [context componentsSeparatedByString:@":"];
    return words.count >= 3;
}

- (NSCharacterSet *)trimmingCharacterSet {
    static NSCharacterSet *_trimmingCharacterSet = nil;
    if (!_trimmingCharacterSet) {
        _trimmingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
    }
    return _trimmingCharacterSet;
}

@end
