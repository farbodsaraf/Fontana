//
//  FNTPleaseDonateReminder.h
//  Spreadit
//
//  Created by Marko Hlebar on 26/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FNTPleaseDonateReminder;
@protocol FNTPleaseDonateReminderDelegate <NSObject>

- (void)reminderShouldRemindToDonate:(FNTPleaseDonateReminder *)reminder;

@end

@interface FNTPleaseDonateReminder : NSObject
@property (nonatomic, weak) id <FNTPleaseDonateReminderDelegate> delegate;

+ (instancetype)reminderForGroup:(NSString *)group;
- (void)bump;

@end
