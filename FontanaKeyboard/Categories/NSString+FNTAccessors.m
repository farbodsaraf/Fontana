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
    NSArray *words = [self componentsSeparatedByString:@" "];
    return words.count;
}

@end
