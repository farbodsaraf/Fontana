//
//  NSString+FNTAccessors.m
//  Spreadit
//
//  Created by Marko Hlebar on 16/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "NSString+FNTAccessors.h"

@implementation NSString (FNTAccessors)

- (NSUInteger)fnt_wordCount {
    __block int words = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0,self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {words++;}];
    return words;
}

- (BOOL)fnt_isEmpty {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string.length == 0;
}

- (NSString *)fnt_underscoredCapitalizedString {
    NSString *original = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    original = [original capitalizedString];
    NSString *underscored = [original stringByReplacingOccurrencesOfString:@"[ ]+"
                                                                withString:@"_"
                                                                   options:NSRegularExpressionSearch
                                                                     range:NSMakeRange(0, original.length)];
    return underscored;
}

@end
