//
//  FNTContextParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTContextParser.h"

static NSString * const kFNTContextItemLinkSeparator = @":";

@interface FNTContextItem ()
@property (nonatomic) NSRange range;
@property (nonatomic, copy) NSString *query;

- (instancetype)initWithQuery:(NSString *)query
                        range:(NSRange)range;

@end

@implementation FNTContextItem

- (instancetype)initWithQuery:(NSString *)query
                        range:(NSRange)range {
    if (self = [super init]) {
        _query = query.copy;
        _range = range;
    }
    
    return self;
}

@end

@implementation FNTContextParser

+ (NSArray *)parseContext:(NSString *)context {
    NSMutableArray *items = [NSMutableArray new];
    NSMutableString *linkString = [NSMutableString new];
    
    NSUInteger startPointer = NSNotFound;
    BOOL readLink = NO;
    for (NSUInteger pointer = 0; pointer < context.length; pointer++) {
        NSString *substring = [context substringWithRange:NSMakeRange(pointer, 1)];
        
        if ([substring isEqualToString:kFNTContextItemLinkSeparator]) {
            readLink = !readLink;
            
            if (readLink) {
                startPointer = pointer;
            }
            else {
                NSRange range = NSMakeRange(startPointer, pointer - startPointer);
                FNTContextItem *item = [[FNTContextItem alloc] initWithQuery:linkString
                                                                       range:range];
                [items addObject:item];
                [linkString setString:@""];
            }
            
            continue;
        }
        
        if (readLink) {
            [linkString appendString:substring];
        }
    }
    
    return items.copy;
}

@end
