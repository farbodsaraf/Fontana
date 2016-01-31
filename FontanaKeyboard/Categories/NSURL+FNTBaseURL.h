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

- (NSURL *)fnt_root;

/**
 *  Returns a domain name by cutting away the domain extension as listed here
 *  https://publicsuffix.org/list/effective_tld_names.dat
 *
 *  @return a domainName.
 */
- (NSString *)fnt_domainName;

@end
