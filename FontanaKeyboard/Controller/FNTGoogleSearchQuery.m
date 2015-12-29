//
//  FNTGoogleSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleSearchQuery.h"
#import "FNTItem.h"
#import "FNTMockFactory.h"
#import "FNTGoogleItemParser.h"
#import <UIKit/UIKit.h>

NSString *const kFNTGoogleSearchString = @"https://www.googleapis.com/customsearch/v1?key=AIzaSyAy5gxcPstj94UatXV_8bgUL_rZjgcjt7Y&cx=017888679784784333058:un3lzj234sa&q=%@&start=1";

@implementation FNTGoogleSearchQuery

- (NSString *)searchURLFormat {
    return kFNTGoogleSearchString;
}

- (Class)parserClass {
    return FNTGoogleItemParser.class;
}

@end
