//
//  FNTItem.h
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNTItem : NSObject <NSCoding>

@property (nonatomic, copy, readonly) NSDictionary *dictionary;
@property (nonatomic, copy, readonly) NSURL *link;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *thumbnailURL;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *snippet;
@property (nonatomic, copy, readonly) NSURL *faviconURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
