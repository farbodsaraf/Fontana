//
//  FNTKeyboardItemCellModel.m
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardItemCellModel.h"
#import "FNTItem.h"

@interface FNTKeyboardItemCellModel ()
@property (nonatomic, copy) UIImage *image;
@end

@implementation FNTKeyboardItemCellModel
BINDINGS(FNTItem,
         BINDModel(title, ~>, text),
         BINDModel(link, ~>, url),
         BINDModel(thumbnailURL, ~>, thumbnailURL),
         nil
         )

- (void)setThumbnailURL:(NSURL *)thumbnailURL {
    _thumbnailURL = thumbnailURL;
    [self downloadImageWithURL:_thumbnailURL];
}

- (void)downloadImageWithURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               if (data) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   if (image) {
                                       self.image = image;
                                   }
                               }
                           }];
}

@end
