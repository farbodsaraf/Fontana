//
//  FNTGoogleScraperSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 30/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleScraperSearchQuery.h"
#import "FNTGoogleScraperItemParser.h"
#import <UIKit/UIKit.h>

@implementation FNTGoogleScraperSearchQuery

- (NSString *)searchURLFormat {
    return @"https://www.google.com/search?q=%@";
}

- (Class)parserClass {
    return FNTGoogleScraperItemParser.class;
}

@end
