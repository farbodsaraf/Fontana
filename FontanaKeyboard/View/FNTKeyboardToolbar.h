//
//  FNTKeyboardToolbar.h
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FNTKeyboardToolbarDelegate <NSObject, UIToolbarDelegate>
@required
- (void)toolbarDidSelectNextKeyboard:(id)toolbar;
- (void)toolbarDidUndo:(id)toolbar;

@end

@interface FNTKeyboardToolbar : UIToolbar
@property (nonatomic, weak) id <FNTKeyboardToolbarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoBarButtonItem;
@end
