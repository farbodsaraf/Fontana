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
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation FNTKeyboardItemCell
BINDINGS(FNTKeyboardItemCellModel,
         [BINDViewModel(image, ~>, imageView.image) observe:^(id observable, id value, NSDictionary *observationInfo) {
    [self setNeedsLayout];
}],
         BINDViewModel(attributedText, ~>, storyLabel.attributedText),
         BINDViewModel(source, ~>, sourceLabel.text),
         BINDT(object, source, ~>, self, backgroundColor, FNTSourceToColorTransformer),
         nil)


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView* selectedBGView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBGView.backgroundColor = [UIColor redColor];
    self.selectedBackgroundView = selectedBGView;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
