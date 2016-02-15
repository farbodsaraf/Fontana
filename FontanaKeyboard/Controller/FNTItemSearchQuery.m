//
//  FNTItemSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTItemSearchQuery.h"
#import "FNTMockFactory.h"
#import "FNTItemParser.h"

@interface FNTItemSearchQuery ()
@property (nonatomic, copy) FNTItemResultBlock itemsBlock;
@property (nonatomic, copy) NSString *searchTerm;
@end

@implementation FNTItemSearchQuery

+ (instancetype)queryWithSearchTerm:(NSString *)searchTerm
                         itemsBlock:(FNTItemResultBlock)itemsBlock {
    id query = [[self alloc] initWithSearchTerm:searchTerm
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
    NSString *urlString = [NSString stringWithFormat:self.searchURLFormat, linkString];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [self requestWithURL:url];
    
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

- (NSURLRequest *)requestWithURL:(NSURL *)url {
    return [NSURLRequest requestWithURL:url];
}

- (void)handleData:(NSData *)data {
    [self handleData:data error:nil];
}

- (void)handleData:(NSData *)data error:(NSError *) error{
    if (error) {
        self.itemsBlock(nil, error);
        return;
    }
    NSError *parseError = nil;
    NSArray *items = [self.parserClass parseData:data error:&parseError];
    self.itemsBlock(items, parseError);
}

- (NSString *)searchURLFormat {
    NSAssert(NO, @"Implement me");
    return nil;
}

- (Class)parserClass {
    NSAssert(NO, @"Implement me");
    return nil;
}

@end
