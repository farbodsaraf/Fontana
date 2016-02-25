//
//  FNTError.m
//  Spreadit
//
//  Created by Marko Hlebar on 19/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTError.h"

NSString *const FNTErrorDomain = @"com.fontana.error";

@implementation FNTError

+ (instancetype)errorWithCode:(FNTErrorCode)code
                      message:(id)message {
    return [FNTError errorWithDomain:FNTErrorDomain
                                code:code
                            userInfo:@{
                                       NSLocalizedDescriptionKey : message
                                       }];
}

@end
