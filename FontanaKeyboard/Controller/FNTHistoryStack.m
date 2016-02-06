//
//  FNTHistoryStack.m
//  Spreadit
//
//  Created by Marko Hlebar on 23/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTHistoryStack.h"

NSString * const kFNTHistoryStackItems = @"kFNTHistoryStackItems";

@interface FNTHistoryStack ()
@property (nonatomic, readonly) NSUserDefaults *defaults;
@property (nonatomic) NSArray *currentItems;
@property (nonatomic, getter=isDirty) BOOL dirty;
@end

@implementation FNTHistoryStack

+ (instancetype)stackForGroup:(NSString *)group {
    return [[self alloc] initWithGroup:group];
}

- (instancetype)initWithGroup:(NSString *)group {
    self = [super init];
    if (self) {
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:group];
        _dirty = YES;
    }
    return self;
}

- (NSArray *)allItems {
    if (self.isDirty) {
        NSData *archivedData = [self.defaults objectForKey:kFNTHistoryStackItems];
        NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        self.currentItems = items ? items : @[];
        self.dirty = NO;
    }
    return self.currentItems;
}

- (void)pushItem:(id <NSCoding> )item {
    if (!item) {
        return;
    }
    
    NSMutableArray *mutableItems = self.allItems.mutableCopy;
    [mutableItems insertObject:item atIndex:0];
    [self archiveItems:mutableItems];
}

- (void)clear {
    [self archiveItems:@[]];
}

- (void)archiveItems:(NSArray *)items {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:items];
    [self.defaults setObject:data forKey:kFNTHistoryStackItems];
    [self.defaults synchronize];
    self.dirty = YES;
}

@end
