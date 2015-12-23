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

- (void)tutorialViewDidFinish:(FNTUsageTutorialView *)tutorialView;

@end

@interface FNTUsageTutorialView : UIView
@property (nonatomic, weak) id <FNTUsageTutorialViewDelegate> delegate;

- (void)start;
- (void)stop;

@end
