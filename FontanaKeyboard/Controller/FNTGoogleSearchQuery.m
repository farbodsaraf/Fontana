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
#import "FNTItemParser.h"

NSString *const kFNTGoogleSearchString = @"https://www.googleapis.com/customsearch/v1?key=AIzaSyAy5gxcPstj94UatXV_8bgUL_rZjgcjt7Y&cx=017888679784784333058:un3lzj234sa&q=%@&start=1";

@interface FNTGoogleSearchQuery ()
@property (nonatomic, copy) FNTItemResultBlock itemsBlock;
@property (nonatomic, copy) NSString *searchTerm;
@end

@implementation FNTGoogleSearchQuery

+ (instancetype)queryWithSearchTerm:(NSString *)searchTerm
                         itemsBlock:(FNTItemResultBlock)itemsBlock {
    FNTGoogleSearchQuery *query = [[self alloc] initWithSearchTerm:searchTerm
                                                        itemsBlock:itemsBlock];
    [query performSearch];
    return query;
}

- (instancetype)initWithSearchTerm:(NSString *)searchTerm
                        itemsBlock:(FNTItemResultBlock)itemsBlock {
    self = [super init];
    if (self) {
        self.searchTerm = searchTerm;
        self.itemsBlock = itemsBlock;
    }
    return self;
}

- (void)performSearch {
    [self searchForLinks:self.searchTerm];
}

- (void)searchForLinks:(NSString *)linkString {
    NSString *urlString = [NSString stringWithFormat:kFNTGoogleSearchString, linkString];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               if (data) {
                                   [weakSelf handleData:data];
                               }
                               else {
#ifdef DEBUG
                                   [weakSelf handleData:FNTMockFactory.mockItems];
#else
                                   weakSelf.itemsBlock(nil, connectionError);
#endif
                               }
                           }];
}

- (void)handleData:(NSData *)data {
    NSArray *items = [FNTItemParser parseData:data error:nil];
    self.itemsBlock(items, nil);
}

@end
