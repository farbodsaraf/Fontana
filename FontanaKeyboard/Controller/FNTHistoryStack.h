//
//  FNTHistoryStack.h
//  Spreadit
//
//  Created by Marko Hlebar on 23/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNTHistoryStack : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)stackForGroup:(NSString *)group;
- (void)pushItem:(id <NSCoding> )item;
- (void)clear;

@end
