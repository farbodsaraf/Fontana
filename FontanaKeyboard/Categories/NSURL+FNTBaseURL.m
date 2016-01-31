//
//  NSURL+FNTBaseURL.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "NSURL+FNTBaseURL.h"
#import "MHFileHandle.h"

@implementation NSURL (FNTBaseURL)

- (NSURL *)fnt_urlByAddingPath:(NSString *)path {
    NSString *urlString = [self.fnt_root.absoluteString stringByAppendingPathComponent:path];
    return [[NSURL URLWithString:urlString] fnt_secureURL];
}

- (NSURL *)fnt_root {
   return [NSURL URLWithString:@"/" relativeToURL:self];
}

- (NSURL *)fnt_secureURL {
    NSString *str = [self absoluteString];
    NSInteger colon = [str rangeOfString:@":"].location;
    if (colon != NSNotFound) {
        str = [str substringFromIndex:colon];
        str = [@"https" stringByAppendingString:str];
    }
    return [NSURL URLWithString:str];
}

- (NSArray *)fnt_domainExtensions {
    static NSArray *_fnt_domainExtensions = nil;
    if (!_fnt_domainExtensions) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"effective_tld_names" ofType:@"dat"];
        NSAssert(filePath, @"Need to read effective_tld_names.dat from the bundle");
        
        NSMutableArray *extensions = [NSMutableArray new];
        
        MHFileHandle *fileHandle = [MHFileHandle handleWithFilePath:filePath];
        NSString *currentLine = nil;
        
        do {
            currentLine = [fileHandle readLine];
            if (currentLine && !([currentLine containsString:@"//"] || [currentLine isEqualToString:@"\n"])) {
                currentLine = [currentLine stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [extensions addObject:currentLine];
            }
        } while (currentLine != nil);
        
        _fnt_domainExtensions = extensions.copy;
    }
    
    return _fnt_domainExtensions;
}

- (NSString *)fnt_domainName {
    NSString *link = self.fnt_root.absoluteString;
    link = [link stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    link = [link stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    link = [link stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSMutableArray *possibleExtensions = [NSMutableArray new];
    for (NSString *domainExtension in self.fnt_domainExtensions) {
        NSRange extensionRange = [link rangeOfString:domainExtension];
        if (extensionRange.location != NSNotFound) {
            if ((extensionRange.location + extensionRange.length) == link.length) {
                [possibleExtensions addObject:domainExtension];
            }
        }
    }
    
    if (possibleExtensions.count > 0) {
        [possibleExtensions sortedArrayUsingSelector:@selector(length)];
        NSString *longestExtension = [possibleExtensions lastObject];
        link = [link stringByReplacingOccurrencesOfString:longestExtension withString:@""];
    }
    
    NSArray *components = [link componentsSeparatedByString:@"."];
    if (components.count >= 2) {
        NSString *source = components[components.count - 2];
        return source;
    }
    
    return @"unknown";
}

@end
