//
//  FNTBINGScraperItemParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 20/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTBINGScraperItemParser.h"
#import <HTMLReader/HTMLReader.h>
#import "FNTError.h"
#import "FNTGoogleItem.h"

@implementation FNTBINGScraperItemParser

+ (NSArray *)parseData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSString *string = nil;
    [NSString stringEncodingForData:data
                    encodingOptions:nil
                    convertedString:&string
                usedLossyConversion:NULL];
    HTMLDocument *document = [HTMLDocument documentWithString:string];
    NSArray *nodes = [document nodesMatchingSelector:@"li"];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(HTMLElement* _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject hasClass:@"b_algo"];
    }];
    
    nodes = [nodes filteredArrayUsingPredicate:predicate];
    
    if (!nodes || nodes.count == 0) {
        *error = [FNTError errorWithCode:FNTErrorCodeNoData
                                 message:@"No data received from bing.com"];
        return nil;
    }
    
    NSMutableArray *items = [NSMutableArray new];
    for (HTMLElement *element in nodes) {
        NSString *title = [self titleFromElement:element];
        if (!title) {
            continue;
        }
        
        NSString *url = [self urlFromElement:element];
        if (!url) {
            continue;
        }
        
        NSDictionary *dictionary = @{
                                     @"link" : url,
                                     @"displayLink" : url,
                                     @"title" : title
                                     };
        FNTGoogleItem *item = [[FNTGoogleItem alloc] initWithDictionary:dictionary];
        [items addObject:item];
    }
    
    return items.copy;
}

+ (NSString *)titleFromElement:(HTMLElement *)element {
    HTMLElement *titleChild = [element.children firstObject];
    return titleChild.textContent;
}

+ (NSString *)urlFromElement:(HTMLElement *)element {
    NSOrderedSet *children = element.children;
    do {
        HTMLElement *nextElement = [children firstObject];
        if ([nextElement respondsToSelector:@selector(attributes)]) {
            NSString *rawElement = nextElement.attributes[@"href"];
            if (rawElement) {
                return rawElement;
            }
        }
        
        children = nextElement.children;
    } while (children);

    return nil;
}

@end
