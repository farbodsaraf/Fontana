//
//  FNTUsageTutorialView.m
//  Spreadit
//
//  Created by Marko Hlebar on 17/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTUsageTutorialView.h"
#import <Masonry/Masonry.h>

@interface FNTUsageTutorialView ()
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, strong) NSTimer *renderTimer;
@property (nonatomic, strong) NSString *usageString;
@property (nonatomic, strong) UILabel *label;
@end

@implementation FNTUsageTutorialView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
        [self addStopGestureRecognizer];
    }
    return self;
}

- (void)addStopGestureRecognizer {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAndRenderText)];
    [self addGestureRecognizer:recognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.frame;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        [_label setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    return _label;
}

- (void)start {
    [self stop];
    self.renderTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(renderNext)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)stop {
    [self.renderTimer invalidate];
    self.renderTimer = nil;
    
    [self.delegate tutorialViewDidFinish:self];
}

- (void)stopAndRenderText {
    [self stop];
    self.label.text = self.usageString;
}

- (void)renderNext {
    NSString *usageString = self.usageString;
    self.currentIndex = ++_currentIndex;
    
    if (self.currentIndex > usageString.length) {
        [self stop];
        return;
    }
    
    self.label.text = [usageString substringToIndex:self.currentIndex];
}

- (NSString *)usageString {
    if (!_usageString) {
        NSString *localizedUsageFormat = NSLocalizedString(@"type\n:%@:\n\nthen press 🌐\nand select Fontana Keyboard...", @"Usage String");
        NSArray *randomTerms = self.randomTerms;
        NSString *randomTerm = randomTerms[arc4random()%randomTerms.count ];
        _usageString = [NSString stringWithFormat:localizedUsageFormat, randomTerm];
    }
    return _usageString;
}

- (NSArray *)randomTerms {
    return @[
             @"Michael Jackson",
             @"Godzilla",
             @"Godfather",
             @"Madonna",
             @"Cry me a river"
             ];
}

@end
