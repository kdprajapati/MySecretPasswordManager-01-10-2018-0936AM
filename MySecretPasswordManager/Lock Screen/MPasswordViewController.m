//
//  MPasscodeViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 06/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "MPasswordViewController.h"
#import "ViewController.h"
#import "AppData.h"

@interface MPasswordViewController ()

@end

@implementation MPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // Do any additional setup after loading the view from its nib.
    UIImage *imgShow = [UIImage imageNamed:@"textField.png"];
    
    [_passwordField setBackground:imgShow];
    
    self.passwordField.layer.borderWidth = 2;
    self.passwordField.layer.cornerRadius = 4;
    self.passwordField.layer.borderColor = [UIColor colorWithRed:141/255.0 green:115/255.0  blue:198/255.0 alpha:1.0].CGColor;///141, 115, 198
    
    [self funSetTitleAsPerPasscodeMode];
    self.passwordField.delegate = self;
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.tintColor = [UIColor whiteColor];
    self.passwordHintLabel.hidden = true;
}

-(void)viewWillAppear:(BOOL)animated
{
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;*/
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setTintColor:[UIColor clearColor]];
    
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.passwordField becomeFirstResponder];
}

-(void)funSetTitleAsPerPasscodeMode
{
    if (self.passwordModeType == FirstTimePasswrod)
    {
        self.titleText.text = @"Set Your Passwrod";
    }
    else if (self.passwordModeType == ReEnterPasswrod)
    {
        self.titleText.text = @"Re-Enter Passwrod";
    }
    else if (self.passwordModeType == EnterPasswrodToResetPasswrod)
    {
        self.titleText.text = @"Enter current Passwrod to Reset!";
    }
    else if (self.passwordModeType == EnterNewPasswrodToReset)
    {
        self.titleText.text = @"Enter New Passwrod to Reset!";
    }
    else if (self.passwordModeType == ReEnterToResetPasswrod)
    {
        self.titleText.text = @"Re-Enter Passwrod";
    }
    else
    {
        self.titleText.text = @"Enter Password";
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController])
    {
        [self funPopToSettingsViewController];
    }
    
}

-(void)funPopToSettingsViewController
{
    NSArray *arrayControllers = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[arrayControllers objectAtIndex:1] animated:true];
}

-(void)funCheckPassword
{
    
    if (self.passwordModeType == FirstTimePasswrod)
    {
        MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
        homeVc.passwordModeType = 1;
        homeVc.passwordToReEnter = self.passwordStr;
//        [self.navigationController pushViewController:homeVc animated:true];
        [self presentViewController:homeVc animated:false completion:^{}];
    }
    else if (self.passwordModeType == ReEnterPasswrod || self.passwordModeType == ReEnterToResetPasswrod)
    {
        if ([self.passwordToReEnter isEqualToString:self.passwordStr])
        {
            NSLog(@"Set success");
            
            if (self.passwordModeType == ReEnterToResetPasswrod)
            {
                //decrypt/encrypt all data
                [[AppData sharedAppData] funDecryptEncryptDataForPasswordReset:self.passwordStr];
            }
            
            //Here, first get current passcode decrypt all data using it.
            // Then using new passcode encrypt it.
            // change in memory appPasscode
            [AppData sharedAppData].userAppPassword = self.passwordStr;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.passwordStr forKey:@"APP_Password"];
            [defaults synchronize];
            
            self.titleText.text = @"Passcode set successful!";
            
            //ask for mail
            
//            [self funAskMailAlert];
            //first ask hint then ask for mail
            [self funShowEnterHintAlert];
            
        }
        else
        {
            NSLog(@"Set Failed");
            self.passwordStr = @"";
            self.titleText.text = @"Passcode not matched, Try Again!";
            
            [self performSelector:@selector(funSetTitleAsPerPasscodeMode) withObject:nil afterDelay:2.0];
        }
    }
    else if (self.passwordModeType == EnterPasswrodToResetPasswrod)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [defaults objectForKey:@"APP_Password"];
        if ([code isEqualToString:self.passwordStr])
        {
            self.titleText.text = @"Success";
            
            MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
            homeVc.passwordModeType = EnterNewPasscodeToReset;
            [self.navigationController pushViewController:homeVc animated:true];
            
        }
        else
        {
            self.passwordStr = @"";
            self.titleText.text = @"Wrong Passcode, Try Again!";
            
            [self performSelector:@selector(funSetTitleAsPerPasscodeMode) withObject:nil afterDelay:2.0];
            
            [self funShowHintLabel];
        }
    }
    else if (self.passwordModeType == EnterNewPasswrodToReset)
    {
        MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
        homeVc.passwordModeType = ReEnterToResetPasscode;
        homeVc.passwordToReEnter = self.passwordStr;
        [self.navigationController pushViewController:homeVc animated:true];
    }
    else
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [defaults objectForKey:@"APP_Password"];
        if ([code isEqualToString:self.passwordStr])
        {
            //Set in memory app password
            [AppData sharedAppData].userAppPassword = self.passwordStr;
            
            self.titleText.text = @"Login Successful!";
            [self performSelector:@selector(funLoadMainMenu) withObject:nil afterDelay:0.5];
            
            [AppData sharedAppData].numOfTimeWrong = 0;
            
            //Call security timer method
            AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate funOpenSecurityAfterSomeMins];
        }
        else
        {
            self.passwordStr = @"";
            self.titleText.text = @"Wrong Passcode, Try Again!";
            
            [self performSelector:@selector(funSetTitleAsPerPasscodeMode) withObject:nil afterDelay:2.0];
            
            [self funShowHintLabel];
        }
    }
}

-(void)funShowHintLabel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *hintText = [defaults valueForKey:@"APP_Password_Hint"];
    if (hintText != nil && ![hintText isEqualToString:@"(null)"])
    {
        self.passwordHintLabel.hidden = false;
        self.passwordHintLabel.text = [NSString stringWithFormat:@"Hint : %@",hintText];
    }
}

-(void)funShowEnterHintAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Password Hint" message:@"Set Password hint. So, you can easily remember your Password." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Password Hint";
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Current password %@", [[alertController textFields][0] text]);
        //compare the current password and do action here
        NSString *hintText = [[alertController textFields][0] text];
        if (hintText != nil && ![hintText isEqualToString:@"(null)"] && hintText.length > 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:hintText forKey:@"APP_Password_Hint"];
            [defaults synchronize];
            
            [self funAskMailAlert];
        }
        else
        {
            [self funShowEnterHintAlert];
        }
        
    }];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)funAskMailAlert
{
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Alert!!" message:@"Would you like to email your password?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [self funOpenEmailController];
                             
                         }];
    
    UIAlertAction* no = [UIAlertAction actionWithTitle:@"No"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [self performSelector:@selector(funOpenMainMenuOrPopToSettings) withObject:nil afterDelay:0.5];
                             
                         }];
    [alert addAction:yes];
    [alert addAction:no];
    
    
    UIViewController *topViewController = appdelegate.window.rootViewController;
    while (topViewController.presentedViewController)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    [topViewController presentViewController:alert animated:YES completion:nil];
}

-(void)funOpenEmailController
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
//        [composeViewController setToRecipients:@[@"example@email.com"]];
        [composeViewController setSubject:@"My Secret Password Manager - Password"];
        [composeViewController setMessageBody:[NSString stringWithFormat:@"Password is: %@",self.passwordStr] isHTML:false];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Alert!!" message:@"Can not send Email. Please set email account.!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  [self funOpenMainMenuOrPopToSettings];
                              }];
        [alert addAction:ok];
        
        
        UIViewController *topViewController = appdelegate.window.rootViewController;
        while (topViewController.presentedViewController)
        {
            topViewController = topViewController.presentedViewController;
        }
        [topViewController presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self funOpenMainMenuOrPopToSettings];
    [controller dismissViewControllerAnimated:true completion:nil];
}

-(void)funOpenMainMenuOrPopToSettings
{
    if (self.passwordModeType == ReEnterToResetPasswrod)
    {
        [self funPopToSettingsViewController];
    }
    else
    {
        [self performSelector:@selector(funLoadMainMenu) withObject:nil afterDelay:0.5];
    }
}

-(void)funLoadMainMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadMainMenuNotification" object:nil];
    
}

#pragma mark :- textfield delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.passwordStr = textField.text;
    
    if (self.passwordStr.length <= 0)
    {
        return false;
    }
    
    [self performSelector:@selector(funCheckPassword) withObject:nil afterDelay:0.3];
    
    [self.passwordField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
