//
//  FNTMockItemSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 31/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTMockItemSearchQuery.h"
#import "FNTMockFactory.h"

@implementation FNTMockItemSearchQuery

- (NSString *)searchURLFormat {
    return @"http://www.google.com/%@";
}

- (Class)parserClass {
    return FNTGoogleItemParser.class;
}

- (void)searchForLinks:(NSString *)linkString {
    [self handleData:[FNTMockFactory mockItems]];
}

@end
