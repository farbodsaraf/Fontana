//
//  FNTUsageTutorialView.m
//  Spreadit
//
//  Created by Marko Hlebar on 17/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTUsageTutorialView.h"
#import "TTTAttributedLabel.h"
#import "UIColor+FNTGenerator.h"

@interface NSString (Substring)
- (NSString *)fnt_substringToIndex:(NSUInteger)index;
@end

@implementation NSString (Substring)
- (NSString *)fnt_substringToIndex:(NSUInteger)index {
    return [self substringToIndex:index];
}
@end

@interface NSAttributedString (Substring)
- (NSAttributedString *)fnt_substringToIndex:(NSUInteger)index;
@end

@implementation NSAttributedString (Substring)
- (NSAttributedString *)fnt_substringToIndex:(NSUInteger)index {
    return [self attributedSubstringFromRange:NSMakeRange(0, index)];
}
@end

@interface FNTUsageTutorialView () <TTTAttributedLabelDelegate>
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, strong) NSTimer *renderTimer;
@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, strong) UIGestureRecognizer *tapGestureRecognizer;
@end

@implementation FNTUsageTutorialView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
    }
    return self;
}

- (void)addStopGestureRecognizer {
    [self removeStopGestureRecognizer];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAndRenderText)];
    [self addGestureRecognizer:recognizer];
    self.tapGestureRecognizer = recognizer;
}

- (void)removeStopGestureRecognizer {
    [self removeGestureRecognizer:self.tapGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.frame;
}

- (UILabel *)label {
    if (!_label) {
        _label = [TTTAttributedLabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        _label.delegate = self;
        [_label setTranslatesAutoresizingMaskIntoConstraints:YES];
        _label.linkAttributes = @{
                                  NSForegroundColorAttributeName: [UIColor fnt_teal],
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                  };
    }
    return _label;
}

- (void)start {
    [self stop];
    [self addStopGestureRecognizer];
    
    float randomTime = [self randomFloatBetween:0.02 and:0.08];
    self.renderTimer = [NSTimer scheduledTimerWithTimeInterval:randomTime
                                                        target:self
                                                      selector:@selector(renderNext)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)stop {
    [self removeStopGestureRecognizer];
    
    [self.renderTimer invalidate];
    self.renderTimer = nil;
    
    if ([self.delegate respondsToSelector:@selector(tutorialViewDidFinish:)]) {
        [self.delegate tutorialViewDidFinish:self];
    }
}

- (void)stopAndRenderText {
    [self stop];
    self.label.text = self.text;
}

- (void)renderNext {
    NSString *text = self.text;
    self.currentIndex = ++_currentIndex;
    
    if (self.currentIndex > text.length) {
        [self stop];
        return;
    }
    
    self.label.text = [text fnt_substringToIndex:self.currentIndex];
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    if ([self.delegate respondsToSelector:@selector(tutorial:willOpenURL:)]) {
        [self.delegate tutorial:self willOpenURL:url];
    }
}

@end
