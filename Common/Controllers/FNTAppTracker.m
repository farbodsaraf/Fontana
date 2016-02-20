//
//  FNTAppTracker.m
//  Spreadit
//
//  Created by Marko Hlebar on 19/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTAppTracker.h"

#import <GoogleTagManager/TAGManager.h>
#import <GoogleTagManager/TAGContainer.h>
#import <GoogleTagManager/TAGContainerOpener.h>
#import <GoogleTagManager/TAGDataLayer.h>
#import <GoogleTagManager/TAGLogger.h>

NSString * const kGTMContainerID = @"GTM-5D242X";

FNTEvent FNTAppTrackerScreenViewEvent = @"screenView";
FNTEvent FNTAppTrackerActionEvent = @"onAction";

FNTTag FNTAppTrackerScreenNameTag = @"screenName";
FNTTag FNTAppTrackerEventActionTag = @"eventAction";

@interface FNTAppTracker () <TAGContainerOpenerNotifier>
@property (nonatomic, strong) TAGManager *tagManager;
@property (nonatomic, strong) TAGContainer *container;
@property (nonatomic, strong) NSOperationQueue *tagQueue;
@end

@implementation FNTAppTracker

+ (instancetype _Nonnull)sharedInstance {
    static FNTAppTracker *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [FNTAppTracker new];
    });
    return _sharedInstance;
}

- (NSOperationQueue *)tagQueue {
    if (!_tagQueue) {
        _tagQueue = [NSOperationQueue new];
        _tagQueue.maxConcurrentOperationCount = 1;
        _tagQueue.suspended = YES;
    }
    return _tagQueue;
}

- (void)startWithPreviewURL:(NSURL * _Nullable)previewUrl {
    self.tagManager = [TAGManager instance];
    
    if (previewUrl != nil) {
        [self.tagManager previewWithUrl:previewUrl];
    }
    
#ifdef DEBUG
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
#else 
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelNone];
#endif
    
    [TAGContainerOpener openContainerWithId:kGTMContainerID
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:nil
                                   notifier:self];
}

+ (void)trackEvent:(FNTEvent)event withTags:(NSDictionary * _Nonnull)tags {
    [self.sharedInstance trackEvent:event withTags:tags];
}

- (void)trackEvent:(FNTEvent)event withTags:(NSDictionary * _Nonnull)tags {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableDictionary *mutableTags = tags.mutableCopy;
        [mutableTags addEntriesFromDictionary:@{
                                                @"event": event
                                                }];
        [self.dataLayer push:mutableTags.copy];
    }];
    
    [self.tagQueue addOperation:operation];
}

+ (id _Nullable)variableForKey:(NSString * _Nonnull)key {
    return [self.sharedInstance variableForKey:key];
}

- (NSString *)variableForKey:(NSString *)key {
    return (NSString *)[self.container stringForKey:key];
}

- (TAGDataLayer *)dataLayer {
    return self.tagManager.dataLayer;
}

- (void)containerAvailable:(TAGContainer *)container {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
        [self.container refresh];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tagQueue.suspended = NO;
        });
    });
}

@end
