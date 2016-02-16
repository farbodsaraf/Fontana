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

+ (instancetype)parserWithOptions:(FNTContextParserOptions)options {
    return [[self alloc] initWithParserOptions:options];
}

- (instancetype)init {
    return [self initWithParserOptions:FNTContextParserOptionsMarkup];
}

- (instancetype)initWithParserOptions:(FNTContextParserOptions)options {
    self = [super init];
    if (self) {
        _options = options;
        _maxOptionalWordsCount = 5;
    }
    return self;
}

- (NSArray *)parseContext:(NSString *)context {
    if (context.length == 0) {
        return @[];
    }
    
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
                NSRange range = NSMakeRange(startPointer, pointer - startPointer + 1);
                NSString *trimmedQuery = [linkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                FNTContextItem *item = [[FNTContextItem alloc] initWithQuery:trimmedQuery
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

- (BOOL)isContextReadyForOptionalMarkup:(NSString *)context {
    if ([self contextHasMarkup:context]) {
        return NO;
    }
    NSArray *words = [context componentsSeparatedByString:@" "];
    return words.count <= self.maxOptionalWordsCount;
}

- (BOOL)contextHasMarkup:(NSString *)context {
    //:word: produces [@"", @"word", @""]
    NSArray *words = [context componentsSeparatedByString:@":"];
    return words.count >= 3;
}

@end
