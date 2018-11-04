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
    
    self.view.backgroundColor = [[AppData sharedAppData] funGetThemeColor];
    
    self.dotOne.layer.cornerRadius = self.dotOne.frame.size.height/2;
    self.dotOne.layer.borderWidth = 2;
    self.dotOne.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dotOne.backgroundColor = [UIColor clearColor];
    
    self.dotTwo.layer.cornerRadius = self.dotTwo.frame.size.height/2;
    self.dotTwo.layer.borderWidth = 2;
    self.dotTwo.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dotTwo.backgroundColor = [UIColor clearColor];
    
    self.dotThree.layer.cornerRadius = self.dotThree.frame.size.height/2;
    self.dotThree.layer.borderWidth = 2;
    self.dotThree.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dotThree.backgroundColor = [UIColor clearColor];
    
    self.dotFour.layer.cornerRadius = self.dotFour.frame.size.height/2;
    self.dotFour.layer.borderWidth = 2;
    self.dotFour.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dotFour.backgroundColor = [UIColor clearColor];
    
    self.oneBtn.layer.borderWidth = 0.3;
    self.oneBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.twoBtn.layer.borderWidth = 0.3;
    self.twoBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.threeBtn.layer.borderWidth = 0.3;
    self.threeBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.fourBtn.layer.borderWidth = 0.3;
    self.fourBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.fiveBtn.layer.borderWidth = 0.3;
    self.fiveBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.sixBtn.layer.borderWidth = 0.3;
    self.sixBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.sevenBtn.layer.borderWidth = 0.3;
    self.sevenBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.eightBtn.layer.borderWidth = 0.3;
    self.eightBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.nineBtn.layer.borderWidth = 0.3;
    self.nineBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.zeroBtn.layer.borderWidth = 0.3;
    self.zeroBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.forgotBtn.layer.borderWidth = 0.3;
    self.forgotBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    self.cancelBtn.layer.borderWidth = 0.3;
    self.cancelBtn.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:1.0].CGColor;
    
    [self funSetThemeIcon];
    
    self.title = @"Passcode";
}

-(void)funSetThemeIcon
{
    //themeIconImageView
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSInteger theme = [userdefaults integerForKey:@"AppTheme"];
    self.themeIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"theme-%ld",(long)theme]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidLayoutSubviews
{
    self.dotOne.frame = CGRectMake(self.dotOne.frame.origin.x, self.dotOne.frame.origin.y, self.dotOne.frame.size.width, self.dotOne.frame.size.width);
    self.dotTwo.frame = CGRectMake(self.dotTwo.frame.origin.x, self.dotTwo.frame.origin.y, self.dotOne.frame.size.width, self.dotOne.frame.size.width);
    self.dotThree.frame = CGRectMake(self.dotThree.frame.origin.x, self.dotThree.frame.origin.y, self.dotOne.frame.size.width, self.dotOne.frame.size.width);
    self.dotFour.frame = CGRectMake(self.dotFour.frame.origin.x, self.dotFour.frame.origin.y, self.dotOne.frame.size.width, self.dotOne.frame.size.width);
    
    self.dotOne.layer.cornerRadius = self.dotOne.frame.size.height/2;
    self.dotTwo.layer.cornerRadius = self.dotTwo.frame.size.height/2;
    self.dotThree.layer.cornerRadius = self.dotThree.frame.size.height/2;
    self.dotFour.layer.cornerRadius = self.dotFour.frame.size.height/2;
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
    [self.navigationController popToViewController:[arrayControllers objectAtIndex:2] animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - button methods
- (IBAction)funTouchDownBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    //e5e5e5 - 229
    [btn setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0]];
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
            self.dotOne.backgroundColor = [UIColor clearColor];
            self.dotTwo.backgroundColor = [UIColor clearColor];
            self.dotThree.backgroundColor = [UIColor clearColor];
            self.dotFour.backgroundColor = [UIColor clearColor];
            break;
        case 1:
            self.dotOne.backgroundColor = [UIColor whiteColor];
            self.dotTwo.backgroundColor = [UIColor clearColor];
            self.dotThree.backgroundColor = [UIColor clearColor];
            self.dotFour.backgroundColor = [UIColor clearColor];
            break;
        case 2:
            self.dotOne.backgroundColor = [UIColor whiteColor];
            self.dotTwo.backgroundColor = [UIColor whiteColor];
            self.dotThree.backgroundColor = [UIColor clearColor];
            self.dotFour.backgroundColor = [UIColor clearColor];
            break;
        case 3:
            self.dotOne.backgroundColor = [UIColor whiteColor];
            self.dotTwo.backgroundColor = [UIColor whiteColor];
            self.dotThree.backgroundColor = [UIColor whiteColor];
            self.dotFour.backgroundColor = [UIColor clearColor];
            break;
        case 4:
            self.dotOne.backgroundColor = [UIColor whiteColor];
            self.dotTwo.backgroundColor = [UIColor whiteColor];
            self.dotThree.backgroundColor = [UIColor whiteColor];
            self.dotFour.backgroundColor = [UIColor whiteColor];
            
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
            
            [defaults setInteger:1 forKey:AppPasscodeOnOffKey];

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
