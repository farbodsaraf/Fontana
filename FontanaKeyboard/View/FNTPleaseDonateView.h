//
//  FNTPleaseDonateView.h
//  Spreadit
//
//  Created by Marko Hlebar on 26/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNTOpenURLProtocol.h"

@protocol FNTPleaseDonateViewDelegate <FNTOpenURLProtocol>
@end

@interface FNTPleaseDonateView : UIView
@property (nonatomic, weak) id <FNTPleaseDonateViewDelegate> delegate;

@end
