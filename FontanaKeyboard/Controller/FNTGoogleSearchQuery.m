//
//  FNTGoogleSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleSearchQuery.h"
#import "FNTItem.h"

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
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               if (data) {
                                   [self handleData:data];
                               }
                               else {
#ifdef DEBUG
                                   [self handleData:self.mockItems];
#else
                                   self.itemsBlock(nil, connectionError);
#endif
                               }
                           }];
}

- (void)handleData:(NSData *)data {
    NSArray *items = [self serializeData:data];
    self.itemsBlock(items, nil);
}

- (NSArray *)serializeData:(id)data {
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:nil];
    NSArray *items = JSON[@"items"];
    NSMutableArray *serializedItems = [NSMutableArray new];
    for (NSDictionary *item in items) {
        FNTItem *serializedItem = [[FNTItem alloc] initWithDictionary:item];
        [serializedItems addObject:serializedItem];
    }
    return serializedItems.copy;
}


- (NSDictionary *)mockDictionaryWithLink:(NSString *)link
                                   title:(NSString *)title
                                thumbURL:(NSString *)thumbURL {
    return @{
             @"link" : link,
             @"title" : title,
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

- (NSData *)mockItems {
    NSString *thumbURL = [[NSBundle mainBundle] pathForResource:@"tux" ofType:@"jpg"];
    
    NSURL *url = [NSURL fileURLWithPath:thumbURL];
    thumbURL = url.absoluteString;
    
    NSDictionary *mockDictionary = @{
                                     @"items" : @[
                                             [self mockDictionaryWithLink:@"http://www.google.com"
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
