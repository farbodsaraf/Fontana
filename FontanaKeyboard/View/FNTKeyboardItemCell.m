//
//  FNTKeyboardItemCell.m
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardItemCell.h"
#import "FNTKeyboardItemCellModel.h"
#import <BIND/BNDURLToImageTransformer.h>

@interface FNTKeyboardItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@end

@implementation FNTKeyboardItemCell
BINDINGS(FNTKeyboardItemCellModel,
         [BINDViewModel(image, ~>, imageView.image) observe:^(id observable, id value, NSDictionary *observationInfo) {
    [self setNeedsLayout];
}],
         BINDViewModel(text, ~>, storyLabel.text),
         nil)

@end
