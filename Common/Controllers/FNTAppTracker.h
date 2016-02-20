//
//  FNTAppTracker.h
//  Spreadit
//
//  Created by Marko Hlebar on 19/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* _Nonnull const FNTEvent;
extern FNTEvent FNTAppTrackerScreenViewEvent;
extern FNTEvent FNTAppTrackerActionEvent;

typedef NSString* _Nonnull const FNTTag;
extern FNTTag FNTAppTrackerScreenNameTag;
extern FNTTag FNTAppTrackerEventActionTag;

@interface FNTAppTracker : NSObject

+ (instancetype _Nonnull)sharedInstance;
- (void)startWithPreviewURL:(NSURL * _Nullable)previewUrl;
+ (void)trackEvent:(FNTEvent)event withTags:(NSDictionary * _Nonnull)tags;

@end
