//
//  NSURL+FNTBaseURL.h
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (FNTBaseURL)

- (NSURL *)fnt_urlByAddingPath:(NSString *)path;

@end
