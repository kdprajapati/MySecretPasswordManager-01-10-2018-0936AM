//
//  SPSecureNotesViewController.h
//  MySecretPasswordManager
//
//  Created by ChirakJMistry on 14/04/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecureNoteObject.h"

@interface SPSecureNotesViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *secureNotesScrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtNoteName;

@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (strong, nonatomic) IBOutlet UITextView *textViewNote;

@property (weak, nonatomic) SecureNoteObject *noteObject;
@property (nonatomic) BOOL isFavourite;
@end
