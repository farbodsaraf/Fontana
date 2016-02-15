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

@interface FNTGoogleScraperSearchQuery () <UIWebViewDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation FNTGoogleScraperSearchQuery

- (NSString *)searchURLFormat {
    return @"https://www.google.com/search?q=%@";
}

- (Class)parserClass {
    return FNTGoogleScraperItemParser.class;
}

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
