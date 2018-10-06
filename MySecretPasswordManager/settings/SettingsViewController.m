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

@interface SettingsViewController ()
{
    NSMutableArray *securityItems;
    NSMutableArray *otherItems;
    AppDelegate *appdelegate;
    NSString *askPasscodeAfterString;
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
    [securityItems addObject:@"Change Password"];
    [securityItems addObject:@"Change PIN"];
    [securityItems addObject:askPasscodeAfterString];
//    [securityItems addObject:@"Email Account"];
    
    
    //otherItems allocation
    otherItems = [[NSMutableArray alloc] init];
    [otherItems addObject:@"Remove Ads"];
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
        if (indexPath.row == 2)
        {
            cell.textLabel.text = askPasscodeAfterString;
        }
        else
        {
            cell.textLabel.text = [securityItems objectAtIndex:indexPath.row];
            if (indexPath.row == 1)
            {
                UISwitch *switchPIN = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 6, 60, 30)];
                [switchPIN addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switchPIN];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSInteger onOffStatus = [[defaults valueForKey:AppPasscodeOnOffKey] integerValue];
                if (onOffStatus == 1)
                {
                    [switchPIN setOn:true];
                }
                else
                {
                    [switchPIN setOn:false];
                }
            }
        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [otherItems objectAtIndex:indexPath.row];

    }
    else
    {
        cell.textLabel.text = @"";
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
    
}

- (void)changeSwitch:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([sender isOn]){
        NSLog(@"Switch is ON");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *code = [defaults objectForKey:@"APP_Passcode"];
        if (code == nil || [code isEqualToString:@""])
        {
            //push passcode viewcontroller to set first time
            [self funChangePasscode];
            [sender setOn:false];
            [defaults setInteger:0 forKey:AppPasscodeOnOffKey];
        }
        else
        {
            [defaults setInteger:1 forKey:AppPasscodeOnOffKey];
        }
        
        
    } else{
        NSLog(@"Switch is OFF");
        [defaults setInteger:0 forKey:AppPasscodeOnOffKey];
    }
    [defaults synchronize];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        //change passcode
        [self funChangePassword];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //change passcode
        [self funChangePasscode];
    }
    //funChangePassword
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        [self funChooseAppLockTime];
    }
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
 UIAlertController
 *actionSheet = [UIAlertController
 alertControllerWithTitle:@"Action
 Sheet"
 message:@"Action
 Sheet example using UIAlertController "
 preferredStyle:UIAlertControllerStyleActionSheet];
 [actionSheet
 addAction:[UIAlertAction
 actionWithTitle:@"Cancel"
 style:UIAlertActionStyleCancel
 handler:^(UIAlertAction
 *action) {
 NSLog(@"Cancel
 button tapped");
 [self
 dismissViewControllerAnimated:YES
 completion:^{
 }];
 }]];
 [actionSheet
 addAction:[UIAlertAction
 actionWithTitle:@"Delete"
 style:UIAlertActionStyleDestructive
 handler:^(UIAlertAction
 *action) {
 NSLog(@"Delete
 button tapped");
 [self
 dismissViewControllerAnimated:YES
 completion:^{
 }];
 }]];
 [actionSheet
 addAction:[UIAlertAction
 actionWithTitle:@"Create"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction
 *action) {
 NSLog(@"Create
 button tapped");
 [self
 dismissViewControllerAnimated:YES
 completion:^{
 }];
 }]];
 [actionSheet
 addAction:[UIAlertAction
 actionWithTitle:@"Select
 All"
 style:UIAlertActionStyleDefault
 handler:^(UIAlertAction
 *action) {
 NSLog(@"Select
 All button tapped");
 [self
 dismissViewControllerAnimated:YES
 completion:^{
 }];
 }]];
 [self
 presentViewController:actionSheet
 animated:YES
 completion:nil];
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
