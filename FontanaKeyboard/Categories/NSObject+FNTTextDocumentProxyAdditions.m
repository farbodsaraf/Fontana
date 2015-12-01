//
//  NSObject+FNTTextDocumentProxyAdditions.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "NSObject+FNTTextDocumentProxyAdditions.h"

@interface NSArray (FNTReverse)

@end

@implementation NSArray (FNTReverse)

- (NSArray *)fnt_reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

#define DELAY_LENGTH 0.001

@implementation NSObject (UITextDocumentProxyAdditions)

- (void)fnt_readText:(void(^)(NSString *textBeforeCursor, NSString *textAfterCursor))returnBlock {
    static dispatch_queue_t inputQueue = NULL;
    
    if (!inputQueue) {
        inputQueue = dispatch_queue_create("com.squid.fontana.documentproxyreadingqueue", NULL);
    }
    
    dispatch_async(inputQueue, ^{
        
        NSString *beforeString = nil;
        NSString *afterString = nil;
        [self readStringsBeforeCursor:&beforeString afterCursor:&afterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            returnBlock(beforeString, afterString);
        });
    });
    return;
}

-(void)readStringsBeforeCursor:(NSString **)beforeString afterCursor:(NSString **) afterString{
    id<UITextDocumentProxy> proxy = (id <UITextDocumentProxy>) self;
    NSString* before = [proxy documentContextBeforeInput];
    NSString* after = [proxy documentContextAfterInput];
    
    NSMutableArray* afterArray = [NSMutableArray arrayWithCapacity:10];
    
    while (after) {
        unsigned long afterLength = [after length];
        if(afterLength <= 0){
            break;
        }
        [afterArray addObject:after];
        [self fnt_adjustCursor:afterLength];
        after = [proxy documentContextAfterInput];
    }
    
    NSMutableArray* beforeArray = [NSMutableArray arrayWithCapacity:10];
    
    [NSThread sleepForTimeInterval:DELAY_LENGTH];
    before = [proxy documentContextBeforeInput];
    
    while (before) {
        unsigned long beforeLength = [before length];
        if (beforeLength <= 0) {
            break;
        }
        [beforeArray addObject:before];
        [self fnt_adjustCursor:-beforeLength];
        before = [proxy documentContextBeforeInput];
    }
    
    *beforeString = [self fnt_concatenateStringFromArray:beforeArray reverse:YES];
    *afterString = [self fnt_concatenateStringFromArray:afterArray reverse:NO];
    
    [self fnt_adjustCursor:(*beforeString).length];
}

- (NSString*)fnt_concatenateStringFromArray:(NSArray *)array
                                    reverse:(BOOL)isReverse {
    NSArray* tar = isReverse ? [array fnt_reversedArray] : array;
    NSMutableString* result = [NSMutableString stringWithCapacity:10];
    for (NSString* string in tar) {
        [result appendString:string];
    }
    return result;
}

- (void)fnt_adjustCursor:(NSInteger)offset {
    [NSThread sleepForTimeInterval:DELAY_LENGTH];
    [(id <UITextDocumentProxy>)self adjustTextPositionByCharacterOffset:offset];
    [NSThread sleepForTimeInterval:DELAY_LENGTH];
}

@end
