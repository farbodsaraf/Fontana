//
//  FNTPleaseDonateReminder.m
//  Spreadit
//
//  Created by Marko Hlebar on 26/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTPleaseDonateReminder.h"

static NSUInteger kPleaseDonateModulo = 2;
static NSString * const kFNTPleaseDonateBumpTimesKey = @"FNTPleaseDonateBumpTimesKey";

@interface FNTPleaseDonateReminder ()
@property (nonatomic, readonly) NSUserDefaults *defaults;
@property (nonatomic) NSUInteger bumpTimes;
@end

@implementation FNTPleaseDonateReminder

+ (instancetype)reminderForGroup:(NSString *)group {
    return [[self alloc] initWithGroup:group];
}

- (instancetype)initWithGroup:(NSString *)group {
    self = [super init];
    if (self) {
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:group];
        _bumpTimes = [[_defaults objectForKey:kFNTPleaseDonateBumpTimesKey] unsignedIntegerValue];

    }
    return self;
}

- (void)bump {
    self.bumpTimes++;
    [self save];
    [self notifyIfNeeded];
}

- (void)save {
    [self.defaults setObject:@(self.bumpTimes)
                      forKey:kFNTPleaseDonateBumpTimesKey];
    [self.defaults synchronize];
}

- (void)notifyIfNeeded {
    if ((self.bumpTimes % kPleaseDonateModulo) == 0) {
        [self.delegate reminderShouldRemindToDonate:self];
    }
}

@end
