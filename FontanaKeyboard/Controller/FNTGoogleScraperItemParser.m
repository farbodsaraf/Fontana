//
//  FNTGoogleScraperItemParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 30/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleScraperItemParser.h"
#import "FNTGoogleItem.h"
#import <HTMLReader/HTMLReader.h>
#import "FNTError.h"

@interface FNTGoogleScraperItemParser ()
@end

@implementation FNTGoogleScraperItemParser

+ (NSArray *)parseData:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSString *string = nil;
    [NSString stringEncodingForData:data
                    encodingOptions:nil
                    convertedString:&string
                usedLossyConversion:NULL];
    HTMLDocument *document = [HTMLDocument documentWithString:string];
    NSArray *nodes = [document nodesMatchingSelector:@"h3"];
    
    if (!nodes || nodes.count == 0) {
        *error = [FNTError errorWithCode:FNTErrorCodeNoData
                                 message:@"No data received from google.com"];
        return nil;
    }

    NSMutableArray *items = [NSMutableArray new];
    for (HTMLElement *element in nodes) {
        NSString *title = element.textContent;
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

+ (NSString *)urlFromElement:(HTMLElement *)element {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF isKindOfClass:%@", [HTMLElement class]];
    NSOrderedSet *htmlElements = [element.children filteredOrderedSetUsingPredicate:predicate];
    HTMLElement *urlElement = [htmlElements firstObject];
    NSString *rawElement = urlElement.attributes[@"href"];
    NSRange hrefRange = [rawElement rangeOfString:@"/url?q="];
    if (hrefRange.location == NSNotFound) {
        return nil;
    }
    NSRange ampRange = [rawElement rangeOfString:@"&sa"];
    if (ampRange.location == NSNotFound) {
        return nil;
    }
    
    NSRange urlRange = NSMakeRange(hrefRange.length, ampRange.location - hrefRange.length);
    return [[rawElement substringWithRange:urlRange] stringByRemovingPercentEncoding];
}

@end
