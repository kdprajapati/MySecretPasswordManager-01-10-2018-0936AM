//
//  SettingsViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 18/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "SettingsViewController.h"
#import "MPassCodeViewController.h"

#import "MPasswordViewController.h"

#import "AppDelegate.h"
#import "AppData.h"

#import "ThemeViewController.h"
#import "PasswordSettingsViewController.h"
#import "PasscodeSettingsViewController.h"
#import "InAppPurchase.h"
@interface SettingsViewController ()
{
    NSMutableArray *securityItems;
    NSMutableArray *otherItems;
    AppDelegate *appdelegate;
    NSString *askPasscodeAfterString;
    UIView *themeColorView;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.settingsTableView.delegate = self;
    self.settingsTableView.dataSource = self;
    
    [self funAllocSectionItems];
    
    self.settingsTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.settingsTableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50);
    if ([[AppData  sharedAppData] isRemoveAdPurchased] == false)
    {
        self.settingsTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        self.settingsTableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
        
    }
    
    self.title = @"Settings";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setTintColor:[UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0]];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0];

    /*[self.navigationController.navigationBar setBackgroundImage:imageNavigation
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;*/

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:true animated:true];
    [[AppData sharedAppData] showAddAtBottom];
    
    [self.settingsTableView reloadData];
}

-(NSString *)funReturnAskPasscodeString
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSInteger lockTime = [userdefaults integerForKey:@"AppLockTime"];
    NSString *lockTimeInMinString;
    switch (lockTime) {
        case 1:
            lockTimeInMinString = @"1 Min";
            break;
        case 2:
            lockTimeInMinString = @"3 Mins";
            break;
        case 3:
            lockTimeInMinString = @"5 Mins";
            break;
            
        default:
            lockTimeInMinString = @"Choose mins";
            break;
    }
    return [NSString stringWithFormat:@"Ask Passcode after - %@",lockTimeInMinString];
}

-(void)funAllocSectionItems
{
    askPasscodeAfterString = [self funReturnAskPasscodeString];
    
    //securityItems allocation
    securityItems = [[NSMutableArray alloc] init];
    [securityItems addObject:@"Password"];
    [securityItems addObject:@"Passcode"];
//    [securityItems addObject:askPasscodeAfterString];
    
    
    //otherItems allocation
    otherItems = [[NSMutableArray alloc] init];
    [otherItems addObject:@"Set a Theme"];
    if (![[AppData sharedAppData] isRemoveAdPurchased])
    {
        [otherItems addObject:@"Remove Ads"];
        [otherItems addObject:@"Restore InApp"];
    }
    else
    {
        
    }
    [otherItems addObject:@"Share This App"];
    [otherItems addObject:@"Rate Us"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark :- tableview data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return securityItems.count;
    }
    if (section == 1)
    {
        return otherItems.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        /*if (indexPath.row == 2)
        {
            cell.textLabel.text = askPasscodeAfterString;
        }
        else
        {*/
            cell.textLabel.text = [securityItems objectAtIndex:indexPath.row];
            
//        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [otherItems objectAtIndex:indexPath.row];

        if (indexPath.row == 0)
        {
            if (themeColorView == nil)
            {
                themeColorView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 10, 30, 30)];
                themeColorView.layer.cornerRadius = 3.0;
                [cell.contentView addSubview:themeColorView];
            }
            [themeColorView setBackgroundColor:[[AppData sharedAppData] funGetThemeColor]];
            
        }
    }
    else
    {
        cell.textLabel.text = @"";
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 44)];
    headerLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [container addSubview:headerLabel];
    if(section == 0)
    {
        headerLabel.text = @"Security";
    }
    else if (section == 1)
    {
        headerLabel.text = @"Others";
    }
    return container;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, container.frame.size.width, 44)];
        headerLabel.text = @"Version 1.0";
        headerLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        headerLabel.textAlignment = UITextAlignmentCenter;
        [container addSubview:headerLabel];
        return container;
    }
    return [[UIView alloc] init];
}

#pragma  mark :- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            //change passcode
            [self funOpenPasswordSettingsViewController];
        }
        else if (indexPath.row == 1) {
            [self funOpenPasscodeSettingsViewController];
        }
        /*else if (indexPath.row == 2)
        {
            [self funChooseAppLockTime];
        }*/
    }
    else if (indexPath.section == 1)
    {
        if (![[AppData sharedAppData] isRemoveAdPurchased])
        {
            if (indexPath.row == 0)
            {
                [self funOpenThemeViewController];
            }
            else if (indexPath.row == 1)
            {
                [self funRemoveAd];
            }
            else if (indexPath.row == 2)
            {
                [self funRestoreInApp];
            }
            else if (indexPath.row == 3)
            {
                //share this app method
                [[AppData sharedAppData] sharePopUpWithTextMessage: @"nPassword Manager - Tired of remembering multiple passwords or forgetting them? Looking for secure & easy way to save all passwords and sensitive data? then you are at right place." image:nil andURL:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",AppId] onViewConrroller:self];
            }
            else if (indexPath.row == 4)
            {
                //Rate US method
                [[AppData sharedAppData] rateUs];
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                [self funOpenThemeViewController];
            }
            else if (indexPath.row == 1)
            {
                //share this app method
                [[AppData sharedAppData] sharePopUpWithTextMessage: @"nPassword Manager - Tired of remembering multiple passwords or forgetting them? Looking for secure & easy way to save all passwords and sensitive data? then you are at right place." image:nil andURL:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",AppId] onViewConrroller:self];
            }
            else if (indexPath.row == 2)
            {
                //Rate US method
                [[AppData sharedAppData] rateUs];
            }
        }
        
    }
    
    
}
-(void)inAppPurchaseDoneForID:(NSString*)strInAppItemID
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isRemoveAdPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [AppData sharedAppData].isRemoveAdPurchased=YES;
    [[AppData sharedAppData].adMob hideAllAds];
    [AppData sharedAppData].adMob=nil;
    
    [self.settingsTableView reloadData];
}
-(void)funRemoveAd
{
    InAppPurchase *inAppPurchase=[InAppPurchase sharedInAppPurchase];
    inAppPurchase.delegate=self;
    [inAppPurchase purchaseProduct:[inAppPurchase getProductWithID:InAppId]];
}

-(void)funRestoreInApp
{
    InAppPurchase *inAppPurchase=[InAppPurchase sharedInAppPurchase];
    inAppPurchase.delegate=self;
    [inAppPurchase restoredInAppPurchased];
    
    [self.settingsTableView reloadData];
}

-(void)showActivityLoader
{
    [[AppData sharedAppData] showActivityLoaderInView:self.view];
}
-(void)hideActivityLoader
{
    [[AppData sharedAppData] hideActivityLoader];
}

-(void)funOpenPasswordSettingsViewController
{
    PasswordSettingsViewController *passwordSettingsVc = [[PasswordSettingsViewController alloc]initWithNibName:@"PasswordSettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:passwordSettingsVc animated:true];
}

-(void)funOpenPasscodeSettingsViewController
{
    PasscodeSettingsViewController *passcodeSettingsVc = [[PasscodeSettingsViewController alloc]initWithNibName:@"PasscodeSettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:passcodeSettingsVc animated:true];
}

-(void)funOpenThemeViewController
{
    ThemeViewController *homeVc = [[ThemeViewController alloc]initWithNibName:@"ThemeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:homeVc animated:true];
}

#pragma mark:- settings helper methods
-(void)funChangePasscode
{
    
    MPassCodeViewController *homeVc = [[MPassCodeViewController alloc]initWithNibName:@"MPassCodeViewController" bundle:[NSBundle mainBundle]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [defaults objectForKey:@"APP_Passcode"];
    if (code == nil || [code isEqualToString:@""])
    {
        homeVc.passcodeModeType = FirstTimePasscode;
    }
    else
    {
        homeVc.passcodeModeType = EnterPasswrodToResetPasswrod;
    }
    
    [self.navigationController pushViewController:homeVc animated:true];
}

-(void)funChangePassword
{
    MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
    homeVc.passwordModeType = EnterPasswrodToResetPasswrod;
    [self.navigationController pushViewController:homeVc animated:true];
}


-(void)funChooseAppLockTime
{
    UIAlertController *alertTime = [UIAlertController alertControllerWithTitle:@"Choose Time" message:@"App will lock after choosen time" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertTime addAction:[UIAlertAction actionWithTitle:@"1 min" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [appdelegate funStartSecurityTimer:1*60];
//        [appdelegate funStartSecurityTimer:10];//test
        [self funUpdateAppLockTime:1];
    }]];
    
    [alertTime addAction:[UIAlertAction actionWithTitle:@"3 min" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [appdelegate funStartSecurityTimer:3*60];
//        [appdelegate funStartSecurityTimer:20];//test
        [self funUpdateAppLockTime:2];
    }]];
    
    [alertTime addAction:[UIAlertAction actionWithTitle:@"5 min" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [appdelegate funStartSecurityTimer:5*60];
//        [appdelegate funStartSecurityTimer:30];//test
        [self funUpdateAppLockTime:3];
    }]];
    
    [alertTime addAction:[UIAlertAction actionWithTitle:@"Ask Every Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [appdelegate funInvalidateSecurityTimer];
        [self funUpdateAppLockTime:0];
    }]];
    
    [alertTime addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertTime animated:YES completion:nil];
}


-(void)funUpdateAppLockTime:(NSInteger)lockTimeCase
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:lockTimeCase forKey:@"AppLockTime"];
    [userdefaults synchronize];
    
    askPasscodeAfterString = [self funReturnAskPasscodeString];
    
    [self.settingsTableView beginUpdates];
    [self.settingsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.settingsTableView endUpdates];
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
