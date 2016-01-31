//
//  FNTKeyboardItemCell.h
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <BIND/BIND.h>
#import "FNTOpenURLProtocol.h"

@class FNTKeyboardItemCell;
@protocol FNTKeyboardItemCellDelegate <FNTOpenURLProtocol>
@end

@interface FNTKeyboardItemCell : BNDCollectionViewCell
@property (nonatomic, weak) id <FNTKeyboardItemCellDelegate> delegate;
@end
