//
//  FNTOpenURLProtocol.h
//  Spreadit
//
//  Created by Marko Hlebar on 26/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FNTOpenURLProtocol <NSObject>

- (void)sender:(id)sender wantsToOpenURL:(NSURL*)url;

@end
