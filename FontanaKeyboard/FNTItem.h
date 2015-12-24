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
@property (nonatomic, strong, readonly) NSURL *link;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *thumbnailURL;
@property (nonatomic, strong, readonly) NSString *source;
@property (nonatomic, strong, readonly) NSString *snippet;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
