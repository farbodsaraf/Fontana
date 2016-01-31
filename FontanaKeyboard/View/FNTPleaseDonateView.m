//
//  FNTPleaseDonateView.m
//  Spreadit
//
//  Created by Marko Hlebar on 26/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTPleaseDonateView.h"

@interface FNTPleaseDonateView ()
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@end

@implementation FNTPleaseDonateView

- (IBAction)onDonate:(id)sender {
    [self.delegate sender:self
           wantsToOpenURL:[NSURL URLWithString:@"fontanakey://donate"]];
}

@end
