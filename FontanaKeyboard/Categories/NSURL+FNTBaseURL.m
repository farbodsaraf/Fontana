//
//  NSURL+FNTBaseURL.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "NSURL+FNTBaseURL.h"

@implementation NSURL (FNTBaseURL)

- (NSURL *)fnt_urlByAddingPath:(NSString *)path {
    NSURL *root = [NSURL URLWithString:@"/" relativeToURL:self];
    NSString *urlString = [root.absoluteString stringByAppendingPathComponent:path];
    return [[NSURL URLWithString:urlString] fnt_secureURL];
}

- (NSURL *)fnt_secureURL {
    NSString *str = [self absoluteString];
    NSInteger colon = [str rangeOfString:@":"].location;
    if (colon != NSNotFound) {
        str = [str substringFromIndex:colon];
        str = [@"https" stringByAppendingString:str];
    }
    return [NSURL URLWithString:str];
}

@end
