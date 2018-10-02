//
//  ViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 05/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "ViewController.h"
#import "MainMenuCellTableViewCell.h"
#import "SettingsViewController.h"
#import "CategoriesViewController.h"
#import "LoginItemsViewController.h"
#import "CoreDataStackManager.h"
#import "CategoryDetailViewController.h"
#import "FavouriteViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *mainMenuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"My Passwords";
    
    mainMenuItems = [[NSMutableArray alloc] init];
    [mainMenuItems addObject:@"Bank Account"];
    [mainMenuItems addObject:@"Credit Card"];
    [mainMenuItems addObject:@"Login/Password"];
    [mainMenuItems addObject:@"Identity"];
    [mainMenuItems addObject:@"Secure Note"];
    [mainMenuItems addObject:@"Driving Licence"];
    [mainMenuItems addObject:@"Membership"];
    [mainMenuItems addObject:@"Passport"];
    
    self.mainMenuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mainMenuTableView registerClass:[MainMenuCellTableViewCell class] forCellReuseIdentifier:@"MainMenuCell"];
    

    [self funAllocBottomBarButtons];
    
    [[CoreDataStackManager sharedManager] funInitializeCoreData];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:false animated:true];
}

- (void)orientationChanged:(NSNotification *)notification{
    
    NSLog(@"self frame - %@",NSStringFromCGRect(self.view.frame));
    CGFloat yPosition;

    yPosition = self.view.bounds.size.height - 44;
}


/**
 add bottom bar buttons - favourite and settings
 */
-(void)funAllocBottomBarButtons
{
    
    UIBarButtonItem *flexibalSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *favBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [favBtn setImage:[UIImage imageNamed:@"favourite_menu.png"] forState:UIControlStateNormal];
//    [favBtn setImage:[UIImage imageNamed:@"favouriteActive.png"] forState:UIControlStateHighlighted];
    [favBtn addTarget:self action:@selector(funOpenFavouriteViewController) forControlEvents:UIControlEventTouchUpInside];
    favBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIBarButtonItem *favouriteBtn = [[UIBarButtonItem alloc] initWithCustomView:favBtn];
    
    /*UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addBtn setImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(funAddCategories) forControlEvents:UIControlEventTouchUpInside];
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithCustomView:addBtn];*/
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [settingBtn setImage:[UIImage imageNamed:@"Settings.png"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"SettingsActive.png"] forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(funOpenSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.navigationController.toolbarHidden = false;
    self.toolbarItems = [NSArray arrayWithObjects: favouriteBtn,flexibalSpace, settingsBtn, nil];
    
}

#pragma  mark :- Favourite view methods
-(void)funOpenFavouriteViewController
{
    FavouriteViewController *favVC = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:[NSBundle mainBundle]];
    favVC.view.frame = self.view.frame;
    [self.navigationController pushViewController:favVC animated:true];
}

#pragma  mark :- Settings method
-(void)funOpenSettingViewController
{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.view.frame = self.view.frame;
    
    [self.navigationController pushViewController:settingsVC animated:true];
}

#pragma  mark :- Category method
-(void)funAddCategories
{
//    CategoriesViewController *settingsVC = [[CategoriesViewController alloc] init];
    CategoriesViewController *categoryVC = [[CategoriesViewController alloc]initWithNibName:@"CategoriesViewController" bundle:[NSBundle mainBundle]];
    categoryVC.view.frame = self.view.frame;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}

#pragma  mark :- tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PasswordCell";
    
//    MainMenuCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    SWRevealTableViewCell *cell = [self.mainMenuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[SWRevealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.delegate = self;
    cell.dataSource = self;
    cell.cellRevealMode = SWCellRevealModeReversedWithAction;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *menuname;
    
    menuname = [NSString stringWithFormat:@"menu-%ld.png",(long)indexPath.row];
    
//    cell.imgView.image = [UIImage imageNamed:menuname];
    cell.imageView.image = [UIImage imageNamed:menuname];
    cell.lblTitle.text = [mainMenuItems objectAtIndex:indexPath.row];
    
  
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma  mark :- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LoginItemsViewController.m
//    LoginItemsViewController *loginVC = [[LoginItemsViewController alloc]initWithNibName:@"LoginItemsViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:loginVC animated:true];
    
    CategoryDetailViewController *categoryVC = [[CategoryDetailViewController alloc]initWithNibName:@"CategoryDetailViewController" bundle:[NSBundle mainBundle]];
    categoryVC.categoryType = (int)indexPath.row+1;
    categoryVC.title = [mainMenuItems objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:categoryVC animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SWRevel tableviewcell datasource
- (NSArray*)leftButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell
{
    return nil;
}
- (NSArray*)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell
{
    SWCellButtonItem *btn1 = [SWCellButtonItem itemWithTitle:@"Delete" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        
        NSIndexPath *indexPath = [self.mainMenuTableView indexPathForCell:cell];
        
//        PasswordObject *object = [arrPassword objectAtIndex:indexPath.row];
//        [[DbClass database] funDeletePassword:object];
//        [arrPassword removeObject:object];
        [self.mainMenuTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        return true;
    }];
    btn1.tintColor = [UIColor whiteColor];
    btn1.backgroundColor = [UIColor redColor];
    btn1.width = 75;
    

    
    return @[btn1];
}

@end
