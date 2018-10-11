//
//  PasswordSettingsViewController.m
//  MySecretPasswordManager
//
//  Created by Karan on 10/10/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "PasswordSettingsViewController.h"
#import "MPasswordViewController.h"
#import "AppDelegate.h"
#import "AppData.h"

@interface PasswordSettingsViewController ()

@end

@implementation PasswordSettingsViewController
{
    NSMutableArray *passwordItems;
    AppDelegate *appdelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.PasswordSettingsTableView.delegate = self;
    self.PasswordSettingsTableView.dataSource = self;
    
    [self funAllocSectionItems];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:true animated:true];
}

-(void)funAllocSectionItems
{
    passwordItems = [[NSMutableArray alloc] init];
    [passwordItems addObject:@"Change Password"];
}

#pragma  mark :- tableview data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return passwordItems.count;
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
    cell.textLabel.text = [passwordItems objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        //change passcode
        [self funChangePassword];
        return;
    }
    
}

#pragma mark:- settings helper methods

-(void)funChangePassword
{
    MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
    homeVc.passwordModeType = EnterPasswrodToResetPasswrod;
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
