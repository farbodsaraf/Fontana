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

@implementation FNTURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"REQUEST %@", request.URL);
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

@end

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
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 if (data) {
                                                     [weakSelf handleData:data];
                                                 }
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

- (void)printData:(NSData *)data forURL:(NSURL *)url{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    if ([dataString containsString:@"itemscope"]) {
//        NSLog(@"REQUEST AND DATA %@\n\n%@\n\n#################", url, dataString);
    }
}

@end
