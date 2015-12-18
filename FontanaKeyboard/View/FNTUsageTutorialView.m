//
//  FNTUsageTutorialView.m
//  Spreadit
//
//  Created by Marko Hlebar on 17/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTUsageTutorialView.h"

@interface FNTUsageTutorialView ()
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, strong) NSTimer *renderTimer;
@property (nonatomic, strong) NSString *usageString;
@end

@implementation FNTUsageTutorialView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
    }
    return self;
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

- (void)renderNext {
    NSString *usageString = self.usageString;
    self.currentIndex = ++_currentIndex;
    
    if (self.currentIndex > usageString.length) {
        [self stop];
        return;
    }
    
    self.text = [usageString substringToIndex:self.currentIndex];
}

- (NSString *)usageString {
    if (!_usageString) {
        NSString *localizedUsageFormat = NSLocalizedString(@"Type :%@:\n\nthen press 🌐\nand select Fontana Keyboard...", @"Usage String");
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
