//
//  FNTScraperSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 20/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTScraperSearchQuery.h"

@interface FNTScraperSearchQuery () <NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@end


@implementation FNTScraperSearchQuery

- (void)searchForLinks:(NSString *)linkString {
    NSString *urlEncodedQuery = [linkString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *urlString = [NSString stringWithFormat:self.searchURLFormat, urlEncodedQuery];
    NSURL *url = [NSURL URLWithString:urlString];
    [self startTaskWithURL:url];
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)startTaskWithURL:(NSURL *)url {
    __weak typeof(self) weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:10];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                     [weakSelf handleData:data error:error];
                                                 }];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)redirectResponse
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
    NSURLRequest *newRequest = request;
    completionHandler(newRequest);
}

@end
