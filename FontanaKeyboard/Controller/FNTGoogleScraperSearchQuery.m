//
//  FNTGoogleScraperSearchQuery.m
//  Spreadit
//
//  Created by Marko Hlebar on 30/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleScraperSearchQuery.h"
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
//    return @"https://www.google.hr/search?q=%@&cad=h";//@"https://www.google.com/?gws_rd=ssl#q=%@";
    return @"https://www.google.com/search?q=%@";
}

- (void)searchForLinks:(NSString *)linkString {
    NSString *urlString = [NSString stringWithFormat:self.searchURLFormat, linkString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];

    [self startTaskWithURL:url];
//    [self startWebViewWithURL:url];
}

- (void)startTaskWithURL:(NSURL *)url {
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                 [self printData:data forURL:response.URL];
                                             }];
    [task resume];
    
//    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        [self printData:data forURL:response.URL];
//    }];
//    [task resume];
}

- (void)startWebViewWithURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)redirectResponse
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
    NSURLRequest *newRequest = request;
    completionHandler(newRequest);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSCachedURLResponse* response = [[NSURLCache sharedURLCache]
                                     cachedResponseForRequest:[webView request]];
    NSData* data = [response data];
    
    
    self.webView = nil;
}

- (void)printData:(NSData *)data forURL:(NSURL *)url{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    if ([dataString containsString:@"itemscope"]) {
//        NSLog(@"REQUEST AND DATA %@\n\n%@\n\n#################", url, dataString);
    }
}

@end
