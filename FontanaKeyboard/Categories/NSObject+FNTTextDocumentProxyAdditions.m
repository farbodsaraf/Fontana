//
//  NSObject+FNTTextDocumentProxyAdditions.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "NSObject+FNTTextDocumentProxyAdditions.h"

typedef NS_ENUM(BOOL, FNTSearchDirection) {
    FNTSearchDirectionBefore = 0,
    FNTSearchDirectionAfter
};

static int kFNTMaxTriesOnEmptyHit = 100;
static NSTimeInterval kFNTSleepInterval = 0.001;

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

@implementation NSObject (UITextDocumentProxyAdditions)

- (void)fnt_readText:(void(^)(NSString *textBeforeCursor, NSString *textAfterCursor))returnBlock {
    static dispatch_queue_t inputQueue = NULL;
    
    if (!inputQueue) {
        inputQueue = dispatch_queue_create("com.fontanakey.documentproxyreadingqueue", NULL);
    }
    
    dispatch_async(inputQueue, ^{
        
        NSString *beforeString = nil;
        NSString *afterString = nil;
        [self readStringsBeforeCursor:&beforeString afterCursor:&afterString];
        beforeString = beforeString ?: @"";
        afterString = afterString ?: @"";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            returnBlock(beforeString, afterString);
        });
    });
    return;
}

-(void)readStringsBeforeCursor:(NSString **)beforeString afterCursor:(NSString **) afterString{
    *beforeString = [self fnt_findStringInDirection:FNTSearchDirectionBefore];
    [self fnt_adjustCursor:(*beforeString).length];
    
    *afterString = [self fnt_findStringInDirection:FNTSearchDirectionAfter];
    [self fnt_adjustCursor:-(*afterString).length];
}

- (NSString *)fnt_findStringInDirection:(FNTSearchDirection)searchDirection {
    id<UITextDocumentProxy> proxy = (id <UITextDocumentProxy>) self;
    
    SEL proxySelector = searchDirection == FNTSearchDirectionBefore ? @selector(documentContextBeforeInput) : @selector(documentContextAfterInput);
    
    int direction = searchDirection == FNTSearchDirectionBefore ? -1 : 1;
    
    [self fnt_sleep];
    
    NSMutableArray* beforeArray = [NSMutableArray arrayWithCapacity:10];
    NSString* before = [proxy performSelector:proxySelector];
    
    //Sometimes, when the string is \n then the length evaluates as 0 which breaks the loop
    NSUInteger tryNext = 0;
    while (before) {
        unsigned long beforeLength = [before length];
        if (beforeLength <= 0) {
            if (tryNext < kFNTMaxTriesOnEmptyHit) {
                ++tryNext;
            }
            else {
                break;
            }
        }
        
        if (beforeLength > 0) {
            [beforeArray addObject:before];
        }
        [self fnt_adjustCursor:direction * beforeLength];
        before = [proxy performSelector:proxySelector];
    }
    
    return [self fnt_concatenateStringFromArray:beforeArray reverse:!searchDirection];
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
    @try {
        [(id <UITextDocumentProxy>)self adjustTextPositionByCharacterOffset:offset];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [self fnt_sleep];
}

- (void)fnt_sleep {
    [NSThread sleepForTimeInterval:kFNTSleepInterval];
}

- (void)fnt_deleteText:(NSString *)text {
    id <UITextDocumentProxy> proxy = (id <UITextDocumentProxy>)self;
    
    NSUInteger letters = text.length;
    while (letters) {
        [proxy deleteBackward];
        letters--;
    }
}

@end
