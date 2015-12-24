//
//  FNTMockFactory.m
//  Spreadit
//
//  Created by Marko Hlebar on 23/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTMockFactory.h"

@implementation FNTMockFactory

+ (NSDictionary *)mockDictionaryWithLink:(NSString *)link
                                   title:(NSString *)title
                                thumbURL:(NSString *)thumbURL {
    return @{
             @"link" : link,
             @"title" : title,
             @"displayLink" : link,
             @"pagemap" :
                 @{
                     @"cse_thumbnail" : @[
                             @{
                                 @"src" : thumbURL
                                 }
                             ]
                     }
             };
}

+ (NSData *)mockItems {
    NSString *thumbURL = [[NSBundle mainBundle] pathForResource:@"tux" ofType:@"jpg"];
    
    NSURL *url = [NSURL fileURLWithPath:thumbURL];
    thumbURL = url.absoluteString;
    
    NSDictionary *mockDictionary = @{
                                     @"items" : @[
                                             [self mockDictionaryWithLink:@"http://www.spotify.com"
                                                                    title:@"Mean Streets"
                                                                 thumbURL:thumbURL]
                                             ,
                                             [self mockDictionaryWithLink:@"http://www.imdb.com"
                                                                    title:@"Mean Streets"
                                                                 thumbURL:thumbURL]
                                             ,
                                             [self mockDictionaryWithLink:@"http://www.yahoo.com"
                                                                    title:@"Mean Streets"
                                                                 thumbURL:thumbURL]
                                             ,
                                             [self mockDictionaryWithLink:@"http://www.geeks.com"
                                                                    title:@"Mean Streets"
                                                                 thumbURL:thumbURL]
                                             ,
                                             [self mockDictionaryWithLink:@"http://www.yippkiyeeah.com"
                                                                    title:@"Mean Streets"
                                                                 thumbURL:thumbURL]
                                             ]
                                     };
    
    return [NSJSONSerialization dataWithJSONObject:mockDictionary
                                           options:0
                                             error:nil];
}

@end
