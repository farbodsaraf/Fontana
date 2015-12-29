//
//  FNTGoogleItemParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 23/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleItemParser.h"
#import "FNTItem.h"

@implementation FNTGoogleItemParser

+ (NSArray *)parseData:(NSData *)data error:(NSError **)error {
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:nil];
    NSString *dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSISOLatin1StringEncoding];
    
    NSMutableArray *serializedItems = [NSMutableArray new];
    NSArray *items = JSON[@"items"];
    if (items) {
        for (NSDictionary *item in items) {
            FNTItem *serializedItem = [[FNTItem alloc] initWithDictionary:item];
            [serializedItems addObject:serializedItem];
        }
    }
    else {
        NSDictionary *errorDict = JSON[@"error"];
        if (errorDict) {
            NSNumber *code = errorDict[@"code"];
            NSString *message = errorDict[@"message"];
            NSError *jsonError = [NSError errorWithDomain:@"com.fontanakey.app.googlequery"
                                                     code:code.integerValue
                                                 userInfo:@{
                                                            NSLocalizedDescriptionKey : message
                                                            }];
            if (error) {
                *error = jsonError;
            }
        }
    }

    return serializedItems.copy;
}

@end
