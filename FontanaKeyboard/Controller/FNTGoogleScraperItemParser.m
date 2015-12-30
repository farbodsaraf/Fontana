//
//  FNTGoogleScraperItemParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 30/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleScraperItemParser.h"
#import <hpple/TFHpple.h>
#import "FNTGoogleItem.h"

@implementation FNTGoogleScraperItemParser

+ (NSArray *)parseData:(NSData *)data error:(NSError *__autoreleasing *)error {
    TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
    NSArray *elements = [hpple searchWithXPathQuery:@"//h3[@class='r']/a"];
    
    NSMutableArray *items = [NSMutableArray new];
    for (TFHppleElement *element in elements) {
        NSString *url = [self urlFromElement:element];
        if (!url) {
            continue;
        }
        
        NSString *title = [self titleFromElement:element];
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

+ (NSString *)urlFromElement:(TFHppleElement *)element {
    NSString *rawElement = element.raw;
    NSRange hrefRange = [rawElement rangeOfString:@"<a href=\"/url?q="];
    if (hrefRange.location == NSNotFound) {
        return nil;
    }
    NSRange ampRange = [rawElement rangeOfString:@"&amp;sa"];
    NSRange urlRange = NSMakeRange(hrefRange.length, ampRange.location - hrefRange.length);
    return [rawElement substringWithRange:urlRange];
}

+ (NSString *)titleFromElement:(TFHppleElement *)element {
    NSString *rawElement = element.raw;
    NSRange closingBracketRange = [rawElement rangeOfString:@">"];
    NSRange closingARange = [rawElement rangeOfString:@"</a>"];
    NSInteger closingBracketEnd = closingBracketRange.location + 1;
    NSRange titleRange = NSMakeRange(closingBracketEnd, closingARange.location - closingBracketEnd);
    NSString *htmlString = [rawElement substringWithRange:titleRange];
    return [self removeHTLMTagsFromString:htmlString];
}

+ (NSString *)removeHTLMTagsFromString:(NSString *)string {
    static NSRegularExpression *regexp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:kNilOptions error:nil];
    });
    
    return [regexp stringByReplacingMatchesInString:string
                                            options:kNilOptions
                                              range:NSMakeRange(0, string.length)
                                       withTemplate:@""];
}

@end
