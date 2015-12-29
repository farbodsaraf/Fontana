//
//  FNTBINGSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTBINGSearchQuery.h"
#import "FNTBINGItemParser.h"

static NSString *const kFNTBINGSearchString = @"https://api.datamarket.azure.com/Bing/SearchWeb/Web?$format=json&Query='%@'";
static NSString *const kFNTBINGAccountKey = @"g7/4SB4bbbgWkO/Fl415uPLR5YzF9eJ/P5zR/0PZQLk";

@implementation FNTBINGSearchQuery

- (NSString *)searchURLFormat {
    return kFNTBINGSearchString;
}

- (Class)parserClass {
    return FNTBINGItemParser.class;
}

- (NSURLRequest *)requestWithURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", kFNTBINGAccountKey, kFNTBINGAccountKey];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding ];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    return request;
}

@end
