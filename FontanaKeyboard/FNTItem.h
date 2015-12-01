//
//  FNTItem.h
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNTItem : NSObject

@property (nonatomic, strong, readonly) NSURL *link;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *thumbnailURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
