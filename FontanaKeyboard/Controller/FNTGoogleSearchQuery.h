//
//  FNTGoogleSearchQuery.h
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FNTItemResultBlock)(NSArray *, NSError *);

@interface FNTGoogleSearchQuery : NSObject
@property (nonatomic, copy, readonly) FNTItemResultBlock itemsBlock;
@property (nonatomic, copy, readonly) NSString *searchTerm;

+ (instancetype)queryWithSearchTerm:(NSString *)searchTerm
                         itemsBlock:(FNTItemResultBlock)itemsBlock;

@end
