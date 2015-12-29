//
//  FNTKeyboardItemCell.h
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <BIND/BIND.h>

@class FNTKeyboardItemCell;
@protocol FNTKeyboardItemCellDelegate <NSObject>
- (void)cell:(FNTKeyboardItemCell *)cell didTapOnURL:(NSURL *)url;
@end

@interface FNTKeyboardItemCell : BNDCollectionViewCell
@property (nonatomic, weak) id <FNTKeyboardItemCellDelegate> delegate;
@end
