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
//#import "InApp/IAPHelper.swift"
#import "MySecretPasswordManager-Swift.h"
#import "AppData.h"
@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *mainMenuItems;
    UIButton *favBtn;
    UIButton *settingBtn;
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
/*
RazeFaceProducts.store.requestProducts{ [weak self] success, products in
    guard case self = self else { return }
    if success {
        self?.products = products!
        
        self?.tableView.reloadData()
    }
    
    self?.refreshControl?.endRefreshing()
}*/
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(handlePurchaseNotification:) name:@"IAPHelperPurchaseNotification"  object:nil];
    [self.mainMenuTableView reloadData];
}
-(void)handlePurchaseNotification:(NSNotification *)notification
{
    NSLog(@"handlePurchaseNotification");
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:false animated:true];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AppData sharedAppData] showAddOnTopOfToolBar];
    
    [favBtn setTintColor:[[AppData sharedAppData] funGetThemeColor]];
    [settingBtn setTintColor:[[AppData sharedAppData] funGetThemeColor]];
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
    
    UIImage *imageFav = [[UIImage imageNamed:@"Fav_Unselect.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    favBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [favBtn setImage:imageFav forState:UIControlStateNormal];
//    [favBtn setImage:[UIImage imageNamed:@"favouriteActive.png"] forState:UIControlStateHighlighted];
    [favBtn addTarget:self action:@selector(funOpenFavouriteViewController) forControlEvents:UIControlEventTouchUpInside];
    favBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [favBtn setTintColor:[[AppData sharedAppData] funGetThemeColor]];
    UIBarButtonItem *favouriteBtn = [[UIBarButtonItem alloc] initWithCustomView:favBtn];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addBtn setImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(funAddCategories) forControlEvents:UIControlEventTouchUpInside];
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    UIBarButtonItem *plusBtn = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    UIImage *imageSettings = [[UIImage imageNamed:@"Settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [settingBtn setImage:imageSettings forState:UIControlStateNormal];
//    [settingBtn setImage:[UIImage imageNamed:@"SettingsActive.png"] forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(funOpenSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [settingBtn setTintColor:[[AppData sharedAppData] funGetThemeColor]];
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.navigationController.toolbarHidden = false;
    
//    self.toolbarItems = [NSArray arrayWithObjects: favouriteBtn,flexibalSpace, settingsBtn, plusBtn,nil];
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
    /*
//    CategoriesViewController *settingsVC = [[CategoriesViewController alloc] init];
    CategoriesViewController *categoryVC = [[CategoriesViewController alloc]initWithNibName:@"CategoriesViewController" bundle:[NSBundle mainBundle]];
    categoryVC.view.frame = self.view.frame;
    
    [self.navigationController pushViewController:categoryVC animated:true];*/
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
    
  
    NSArray *categoryArray = [[AppData sharedAppData] funGetDetailObject:(indexPath.row + 1) isFavArrayToReturn:false];
    
    int dataCount = 0;
    if (categoryArray != nil)
    {
        dataCount = (int)categoryArray.count;
    }
    cell.lblDataCount.frame = CGRectMake(cell.contentView.frame.size.width - 70, 12, 70, 20);
    cell.lblDataCount.textAlignment = NSTextAlignmentRight;
    cell.lblDataCount.text = [NSString stringWithFormat:@"%d ",dataCount];
    if(dataCount<=0)
    {
        cell.lblDataCount.hidden=YES;
    }
    else
    {
       cell.lblDataCount.hidden=NO;
    }
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
    [[AppData sharedAppData] showAddAtBottom];
    
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
    return nil;
}

@end
