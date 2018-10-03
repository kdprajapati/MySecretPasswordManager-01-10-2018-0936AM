//
//  LoginItemsViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 23/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginPasswordObject.h"
#import "NoteViewController.h"

@interface LoginItemsViewController : UIViewController <UITextFieldDelegate,NoteViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *loginNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *urlWebTxt;
@property (strong, nonatomic) IBOutlet UITextField *usernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong, nonatomic) IBOutlet UITextField *noteTxt;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewLogin;

@property (weak, nonatomic) LoginPasswordObject *loginObject;
@property (nonatomic) BOOL isFavourite;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *favouriteButton;

@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@end
