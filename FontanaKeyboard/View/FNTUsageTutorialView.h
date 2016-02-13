//
//  FNTUsageTutorialView.h
//  Spreadit
//
//  Created by Marko Hlebar on 17/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNTUsageTutorialView;
@protocol FNTUsageTutorialViewDelegate <NSObject>

@optional
- (void)tutorialViewDidFinish:(FNTUsageTutorialView *)tutorialView;
- (void)tutorial:(FNTUsageTutorialView *)tutorialView willOpenURL:(NSURL *)url;

@end

@interface FNTUsageTutorialView : UIView
@property (nonatomic, weak) id <FNTUsageTutorialViewDelegate> delegate;
@property (nonatomic, strong) id text;

- (void)start;
- (void)stop;

@end
