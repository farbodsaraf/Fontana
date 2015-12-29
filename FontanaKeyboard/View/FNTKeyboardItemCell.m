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
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "UIColor+FNTGenerator.h"

@interface FNTKeyboardItemCell () <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *faviconView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *storyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConstraint;
@end

@implementation FNTKeyboardItemCell
BINDINGS(FNTKeyboardItemCellModel,
         [BINDViewModel(image, ~>, imageView.image) observe:^(id observable, id value, NSDictionary *observationInfo) {
    [self setNeedsLayout];
}],
         [BINDViewModel(faviconImage, ~>, faviconView.image) observe:^(id observable, id value, NSDictionary *observationInfo) {
    [self setNeedsLayout];
}],
         BINDViewModel(attributedText, ~>, storyLabel.text),
         BINDViewModel(source, ~>, sourceLabel.text),
         nil)


- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView* selectedView = [[UIView alloc] initWithFrame:self.bounds];
    selectedView.backgroundColor = [UIColor fnt_lightTeal];
    
    self.selectedBackgroundView = selectedView;
    self.separatorHeightConstraint.constant = 0.5f;
    
    self.storyLabel.linkAttributes = @{
                                       NSForegroundColorAttributeName: [UIColor fnt_teal],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                       };
    self.storyLabel.delegate = self;

    self.sourceLabel.textColor = [UIColor fnt_tealLowerAlpha];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [self.delegate cell:self didTapOnURL:url];
}

@end
