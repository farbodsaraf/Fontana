//
//  FNTItemParser.h
//  Spreadit
//
//  Created by Marko Hlebar on 23/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNTItemParser : NSObject
+ (NSArray *)parseData:(NSData *)data error:(NSError **)error;
@end
