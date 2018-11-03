//
//  MPasswordViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 06/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface MPasswordViewController : UIViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate>
{
    enum PasswrodTypeEnum
    {
        FirstTimePasswrod,//0
        ReEnterPasswrod,//1
        EnterPasswrod,//2
        EnterPasswrodToResetPasswrod,//3
        EnterNewPasswrodToReset,//4
        ReEnterToResetPasswrod//5
    } PasswrodType;
    
    
    AppDelegate *appdelegate;
    
}
@property (nonatomic, assign) int passwordModeType;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;

@property (strong, nonatomic) IBOutlet UILabel *titleText;

@property(nonatomic, strong) NSString *passwordStr;

@property(nonatomic, strong) NSString *passwordToReEnter;
@property (strong, nonatomic) IBOutlet UILabel *passwordHintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *themeIconImageView;

@end
