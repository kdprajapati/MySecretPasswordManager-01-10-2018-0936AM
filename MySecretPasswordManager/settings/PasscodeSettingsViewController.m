//
//  PasscodeSettingsViewController.m
//  MySecretPasswordManager
//
//  Created by Karan on 10/10/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "PasscodeSettingsViewController.h"
#import "MPassCodeViewController.h"
#import "MPasswordViewController.h"
#import "AppDelegate.h"
#import "AppData.h"

@interface PasscodeSettingsViewController ()

@end

@implementation PasscodeSettingsViewController
{
    NSMutableArray *passcodeItems;
    AppDelegate *appdelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.PasscodeSettingsTableView.delegate = self;
    self.PasscodeSettingsTableView.dataSource = self;
    
    [self funAllocSectionItems];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:true animated:true];
}

-(void)funAllocSectionItems
{
    passcodeItems = [[NSMutableArray alloc] init];
    [passcodeItems addObject:@"Enable/Disable Passcode"];
    [passcodeItems addObject:@"Change Passcode"];
}

#pragma  mark :- tableview data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return passcodeItems.count;
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

    cell.textLabel.text = [passcodeItems objectAtIndex:indexPath.row];
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
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
    
}

- (void)changeSwitch:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([sender isOn]){
        NSLog(@"Switch is ON");
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


#pragma  mark :- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && indexPath.row == 1) {
        //change passcode
        [self funChangePasscode];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
