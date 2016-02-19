//
//  FNTAppTracker.h
//  Spreadit
//
//  Created by Marko Hlebar on 19/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNTAppTracker : NSObject

+ (instancetype)sharedInstance;
- (void)startWithPreviewURL:(NSURL *)previewUrl;

@end
