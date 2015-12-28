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
#import "FNTSourceToColorTransformer.h"

@interface FNTKeyboardItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConstraint;
@end

@implementation FNTKeyboardItemCell
BINDINGS(FNTKeyboardItemCellModel,
         [BINDViewModel(image, ~>, imageView.image) observe:^(id observable, id value, NSDictionary *observationInfo) {
    [self setNeedsLayout];
}],
         BINDViewModel(attributedText, ~>, storyLabel.attributedText),
         BINDViewModel(source, ~>, sourceLabel.text),
         nil)


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView* selectedView = [[UIView alloc] initWithFrame:self.bounds];
    selectedView.backgroundColor = [UIColor colorWithRed:47./255
                                                   green:143./255
                                                    blue:140./255
                                                   alpha:0.3];
    self.selectedBackgroundView = selectedView;
    self.separatorHeightConstraint.constant = 0.5f;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
