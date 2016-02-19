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

@interface FNTAppTracker () <TAGContainerOpenerNotifier>
@property (nonatomic, strong) TAGManager *tagManager;
@property (nonatomic, strong) TAGContainer *container;
@end

@implementation FNTAppTracker

+ (instancetype)sharedInstance {
    static FNTAppTracker *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [FNTAppTracker new];
    });
    return _sharedInstance;
}

- (void)startWithPreviewURL:(NSURL *)previewUrl {
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

- (void)containerAvailable:(TAGContainer *)container {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
    });
}

@end
