//
//  FNTKeyboardViewModel.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardViewModel.h"
#import "FNTItem.h"
#import "FNTKeyboardItemCellModel.h"

NSString *const kFNTGoogleSearchString = @"https://www.googleapis.com/customsearch/v1?key=AIzaSyAy5gxcPstj94UatXV_8bgUL_rZjgcjt7Y&cx=017888679784784333058:un3lzj234sa&q=%@&start=1";

@interface FNTKeyboardViewModel ()
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, copy) BNDViewModelsBlock viewModelsHandler;
@end

@implementation FNTKeyboardViewModel

- (void)updateWithContext:(NSString *)contextString
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    [self findLinks:contextString];
    self.viewModelsHandler = viewModelsHandler;
}

static NSString * const kLinkSeparator = @":";

- (void)findLinks:(NSString *)string {
    NSMutableString *linkString = [NSMutableString new];
    
    BOOL readLink = NO;
    for (NSUInteger pointer = 0; pointer < string.length; pointer++) {
        NSString *substring = [string substringWithRange:NSMakeRange(pointer, 1)];
        
        if ([substring isEqualToString:kLinkSeparator]) {
            readLink = !readLink;
            continue;
        }
        
        if (readLink) {
            [linkString appendString:substring];
        }
    }
    
    NSLog(@"%@", linkString);
    
    [self searchForLinks:linkString];
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
                                   self.viewModelsHandler(nil, connectionError);
#endif
                               }
                           }];
}

- (void)handleData:(id)data {
    self.results = [self serializeData:data];
    for (FNTItem *item in self.results) {
        FNTKeyboardItemCellModel *cellModel = [FNTKeyboardItemCellModel viewModelWithModel:item];
        [self addChild:cellModel];
    }
    
    self.viewModelsHandler(self.children, nil);
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

@end
