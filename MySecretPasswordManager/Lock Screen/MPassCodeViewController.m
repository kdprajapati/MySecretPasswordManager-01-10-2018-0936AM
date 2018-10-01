//
//  MPassCodeViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 05/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "MPassCodeViewController.h"
#import "ViewController.h"
#import "AppData.h"

@interface MPassCodeViewController ()
{
    NSString *reEnteredCodeStr;
}
@end

@implementation MPassCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.passCodeStr = @"";
    
    [self funSetTitleAsPerPasscodeMode];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)funSetTitleAsPerPasscodeMode
{
    if (self.passcodeModeType == FirstTimePasscode)
    {
        self.labelTitlePasscode.text = @"Enter New Passcode";
    }
    else if (self.passcodeModeType == ReEnterPasscode)
    {
        self.labelTitlePasscode.text = @"Re-Enter Passcode To Set";
    }
    else if (self.passcodeModeType == EnterPasscodeToResetPasscode)
    {
        self.labelTitlePasscode.text = @"Enter current Passcode to Reset!";
    }
    else if (self.passcodeModeType == EnterNewPasscodeToReset)
    {
        self.labelTitlePasscode.text = @"Enter New Passcode to Reset!";
    }
    else if (self.passcodeModeType == ReEnterToResetPasscode)
    {
        self.labelTitlePasscode.text = @"Re-Enter Passcode!";
    }
    else
    {
        self.labelTitlePasscode.text = @"Enter Passcode";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button methods
- (IBAction)funTouchDownBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:212.0/255.0 blue:238.0/255.0 alpha:1.0]];
}
- (IBAction)funDragOutside:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)funEnterPasscode:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor whiteColor]];
    if (self.passCodeStr.length >= 4)
    {
        return;
    }
    

    NSLog(@"btn.titleLabel.text - %@",btn.titleLabel.text);
    self.passCodeStr = [self.passCodeStr stringByAppendingString:btn.titleLabel.text];
    NSLog(@"self.passCodeStr - %@",self.passCodeStr);
    
    [self funChangeDotImage:self.passCodeStr];
    
}


-(void)funChangeDotImage:(NSString *)passcodeEntered
{
    int lengthOfCode = (int)passcodeEntered.length;
    
    switch (lengthOfCode) {
        case 0:
            self.dotOne.image = [UIImage imageNamed:@"Paging.png"];
            self.dotTwo.image = [UIImage imageNamed:@"Paging.png"];
            self.dotThree.image = [UIImage imageNamed:@"Paging.png"];
            self.dotFour.image = [UIImage imageNamed:@"Paging.png"];
            break;
            
        case 1:
            self.dotOne.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotTwo.image = [UIImage imageNamed:@"Paging.png"];
            self.dotThree.image = [UIImage imageNamed:@"Paging.png"];
            self.dotFour.image = [UIImage imageNamed:@"Paging.png"];
            
            break;
        case 2:
            self.dotOne.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotTwo.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotThree.image = [UIImage imageNamed:@"Paging.png"];
            self.dotFour.image = [UIImage imageNamed:@"Paging.png"];
            break;
        case 3:
            self.dotOne.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotTwo.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotThree.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotFour.image = [UIImage imageNamed:@"Paging.png"];
            break;
        case 4:
            self.dotOne.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotTwo.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotThree.image = [UIImage imageNamed:@"PagingActive.png"];
            self.dotFour.image = [UIImage imageNamed:@"PagingActive.png"];
            
            
            [self performSelector:@selector(funCheckPasscode) withObject:nil afterDelay:0.3];
            
            break;
 
    }
    
}

-(void)funCheckPasscode
{
    
    if (self.passcodeModeType == FirstTimePasscode)
    {
        MPassCodeViewController *homeVc = [[MPassCodeViewController alloc]initWithNibName:@"MPassCodeViewController" bundle:[NSBundle mainBundle]];
        homeVc.passcodeModeType = 1;
        homeVc.passCodeToReEnter = self.passCodeStr;
//        [self presentViewController:homeVc animated:false completion:^{}];
        [self.navigationController pushViewController:homeVc animated:true];
    }
    else if (self.passcodeModeType == ReEnterPasscode || self.passcodeModeType == ReEnterToResetPasscode)
    {
        if ([self.passCodeToReEnter isEqualToString:self.passCodeStr])
        {
            NSLog(@"Set success");
            
            /*if (self.passcodeModeType == ReEnterToResetPasscode)
            {
                //decrypt/encrypt all data
                [[AppData sharedAppData] funDecryptEncryptDataForPasswordReset:self.passCodeStr];
            }*/
            
            //Here, first get current passcode decrypt all data using it.
            // Then using new passcode encrypt it.
            // change in memory appPasscode
           //[AppData sharedAppData].userAppPassword = self.passCodeStr;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.passCodeStr forKey:@"APP_Passcode"];
            [defaults synchronize];
            
            self.labelTitlePasscode.text = @"Passcode set successful!";
            
//            [self funLoadMainMenu];
//            if (self.passcodeModeType == ReEnterToResetPasscode)
//            {
                [self funPopToSettingsViewController];
            /*}
            else
            {
                [self performSelector:@selector(funLoadMainMenu) withObject:nil afterDelay:0.5];
            }*/
            
        }
        else
        {
            NSLog(@"Set Failed");
            self.passCodeStr = @"";
            [self funChangeDotImage:self.passCodeStr];
            self.labelTitlePasscode.text = @"Passcode not matched, Try Again!";
            
            [self performSelector:@selector(funSetTitleAsPerPasscodeMode) withObject:nil afterDelay:2.0];
        }
    }
    else if (self.passcodeModeType == EnterPasscodeToResetPasscode)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [defaults objectForKey:@"APP_Passcode"];
        if ([code isEqualToString:self.passCodeStr])
        {
            self.labelTitlePasscode.text = @"Success";
            
            MPassCodeViewController *homeVc = [[MPassCodeViewController alloc]initWithNibName:@"MPassCodeViewController" bundle:[NSBundle mainBundle]];
            homeVc.passcodeModeType = EnterNewPasscodeToReset;
            [self.navigationController pushViewController:homeVc animated:true];
            
        }
        else
        {
            self.passCodeStr = @"";
            [self funChangeDotImage:self.passCodeStr];
            self.labelTitlePasscode.text = @"Wrong Passcode, Try Again!";
            
            [self performSelector:@selector(funSetTitleAsPerPasscodeMode) withObject:nil afterDelay:2.0];
        }
    }
    else if (self.passcodeModeType == EnterNewPasscodeToReset)
    {
        MPassCodeViewController *homeVc = [[MPassCodeViewController alloc]initWithNibName:@"MPassCodeViewController" bundle:[NSBundle mainBundle]];
        homeVc.passcodeModeType = ReEnterToResetPasscode;
        homeVc.passCodeToReEnter = self.passCodeStr;
        [self.navigationController pushViewController:homeVc animated:true];
    }
    else
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [defaults objectForKey:@"APP_Passcode"];
        if ([code isEqualToString:self.passCodeStr])
        {
            //Set in memory app password
            //[AppData sharedAppData].userAppPassword = self.passCodeStr;
            
            self.labelTitlePasscode.text = @"Login Successful!";
            [self performSelector:@selector(funLoadMainMenu) withObject:nil afterDelay:0.5];
            
            [AppData sharedAppData].numOfTimeWrong = 0;
            
            //Call security timer method
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             [appdelegate funOpenSecurityAfterSomeMins];
            
        }
        else
        {
            int numberOfWrongAttempt = [AppData sharedAppData].numOfTimeWrong;
            if (numberOfWrongAttempt >= 2)
            {
                //call masterpassword controller
                AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                [appdelegate funOpenSecurity];
            }
            else
            {
                self.passCodeStr = @"";
                [self funChangeDotImage:self.passCodeStr];
                self.labelTitlePasscode.text = @"Wrong Passcode, Try Again!";
                
                [self performSelector:@selector(funSetTitleAsPerPasscodeMode) withObject:nil afterDelay:2.0];
            }
            [AppData sharedAppData].numOfTimeWrong = numberOfWrongAttempt + 1;
            
        }
    }
}

-(void)funLoadMainMenu
{
    /*UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ViewController *homeVc = (ViewController *)[sb instantiateViewControllerWithIdentifier:@"ViewController"];;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
    
    if (self.isBeingPresented)
    {
        [self dismissViewControllerAnimated:true completion:^{
            
        }];
    }
    else
    {
        window.rootViewController = nav;
        [window makeKeyAndVisible];
    }*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [AppData sharedAppData].userAppPassword = [defaults objectForKey:@"APP_Password"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadMainMenuNotification" object:nil];
    
}

- (IBAction)funCancelPasscode:(id)sender {
    
    if (self.passCodeStr.length > 0)
    {
        NSString *truncatedString = [self.passCodeStr substringToIndex:[self.passCodeStr length]-1];
        self.passCodeStr = truncatedString;
        NSLog(@"truncatedString - %@",self.passCodeStr);
        [self funChangeDotImage:self.passCodeStr];
    }
    else
    {
        [self funChangeDotImage:@""];
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
