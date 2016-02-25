//
//  FNTError.h
//  Spreadit
//
//  Created by Marko Hlebar on 19/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FNTErrorCode) {
    FNTErrorCodeGeneric = 1000,
    FNTErrorCodeNoData,
    FNTErrorCodeInvalidQuery,
    FNTErrorCodeNoFullAccess
};

extern NSString *const FNTErrorDomain;

@interface FNTError : NSError

+ (instancetype)errorWithCode:(FNTErrorCode)code
                      message:(id)message;

@end
