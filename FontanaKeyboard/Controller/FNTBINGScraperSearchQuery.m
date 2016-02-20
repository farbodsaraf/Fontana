//
//  FNTBINGScraperSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 20/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTBINGScraperSearchQuery.h"
#import "FNTBINGScraperItemParser.h"

@implementation FNTBINGScraperSearchQuery

- (NSString *)searchURLFormat {
    return @"https://www.bing.com/search?q=%@";
}

- (Class)parserClass {
    return FNTBINGScraperItemParser.class;
}

@end
