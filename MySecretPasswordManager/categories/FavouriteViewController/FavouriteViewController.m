//
//  FavouriteViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 15/03/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "FavouriteViewController.h"
#import "CoreDataStackManager.h"
#import "BankAccountsViewController.h"
#import "CreditCardViewController.h"
#import "LoginItemsViewController.h"
#import "SPIdentityViewController.h"
#import "SPSecureNotesViewController.h"
#import "SPCategoryDrivingLicenceViewController.h"
#import "SPCategoryMembershipViewController.h"
#import "SPCategoryPassportViewController.h"

#import "SPPreviewViewController.h"
#import "AppData.h"

@interface FavouriteViewController ()
{
    NSMutableArray *detailArray;
    UILabel *labelNoData;

}
@end

@implementation FavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Favourites";
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // Do any additional setup after loading the view from its nib.
    self.favouriteTableView.delegate = self;
    self.favouriteTableView.dataSource = self;
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    labelNoData = [[UILabel  alloc] init];
    labelNoData.frame = CGRectMake(0, self.view.center.y, self.view.frame.size.width, 44);;
    labelNoData.text =  @"No Favourites Yet";
    labelNoData.hidden = true;
    //    labelNoData.center = self.view.center;
    labelNoData.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelNoData];
    
    _favouriteTableView.hidden = true;
}


-(void)viewDidAppear:(BOOL)animated
{
    detailArray = [[AppData sharedAppData] funGetDetailAllFavouriteObjects:true];
    
    [self.favouriteTableView reloadData];
    
    [self funHideShowNoData];
    
    [self.navigationController setToolbarHidden:true animated:true];
    [self.navigationController setToolbarHidden:true animated:true];
    
    [[AppData sharedAppData] showAddAtBottom];
}

-(void)funHideShowNoData
{
    if(detailArray.count > 0)
    {
        labelNoData.hidden = true;
        _favouriteTableView.hidden = false;
    }
    else
    {
        labelNoData.hidden = false;
        _favouriteTableView.hidden = true;
    }
}

#pragma  mark :- tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryDetailCell";
    
    SWRevealTableViewCell *cell = [self.favouriteTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[SWRevealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    cell.delegate = self;
    cell.dataSource = self;
    cell.cellRevealMode = SWCellRevealModeReversedWithAction;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblTitle.text = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    //NSLog(@"cetgory -fav - %@",[[detailArray objectAtIndex:indexPath.row] valueForKey:@"categoryType"]);
    NSNumber *categoryType = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"categoryType"];
    switch (categoryType.intValue) {
        case 1://Bank Account
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-0.png"];
            cell.lblSubTitle.text = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"accountNumber"];
        }
            break;
        case 2://Credit Card
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-1.png"];
            cell.lblSubTitle.text = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"cardNumber"];
        }
            break;
        case 3://Login/Password
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-2.png"];
            cell.lblSubTitle.text = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"username"];
        }
            break;
        case 4:
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-3.png"];
            NSString *firstName = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"firstName"];
            NSString *lastName = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"lastName"];
            cell.lblSubTitle.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        }
            break;
        case 5://Secure notes
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-4.png"];
            NSString *noteDescription = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"note"];
            
            cell.lblSubTitle.text = [NSString stringWithFormat:@"%@",noteDescription];
            
        }
            break;
        case 6://Driving Licence
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-5.png"];
            NSString *licNumber = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"licenceNumber"];
            
            cell.lblSubTitle.text = [NSString stringWithFormat:@"%@",licNumber];
            
        }
            break;
        case 7://Membership
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-6.png"];
            NSString *memberID = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"memberID"];
            
            cell.lblSubTitle.text = [NSString stringWithFormat:@"%@",memberID];
            
        }
            break;
        case 8://Passport
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-7.png"];
            NSString *issuingCountry = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"issuingCountry"];
            
            cell.lblSubTitle.text = [NSString stringWithFormat:@"%@",issuingCountry];
            
        }
            break;
        default:
            break;
    }
    
    return cell;
    
}

#pragma  mark :- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSNumber *categoryType = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"categoryType"];
    
    switch (categoryType.intValue) {
        case 1:
        {
            BankAccountsViewController *categoryVC = [[BankAccountsViewController alloc]initWithNibName:@"SPBankAccountsViewController" bundle:[NSBundle mainBundle]];
            categoryVC.bankObject = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 2:
        {
            CreditCardViewController *categoryVC = [[CreditCardViewController alloc]initWithNibName:@"SPCreditCardViewController" bundle:[NSBundle mainBundle]];
            categoryVC.ObjectCreditCard = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 3:
        {
            LoginItemsViewController *categoryVC = [[LoginItemsViewController alloc]initWithNibName:@"LoginItemsViewController" bundle:[NSBundle mainBundle]];
            categoryVC.loginObject = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 4:
        {
            SPIdentityViewController *categoryVC = [[SPIdentityViewController alloc]initWithNibName:@"SPIdentityViewController" bundle:[NSBundle mainBundle]];
            categoryVC.identityObject = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 5:
        {
            SPSecureNotesViewController *categoryVC = [[SPSecureNotesViewController alloc]initWithNibName:@"SPSecureNotesViewController" bundle:[NSBundle mainBundle]];
            categoryVC.noteObject = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 6:
        {
            SPCategoryDrivingLicenceViewController *categoryVC = [[SPCategoryDrivingLicenceViewController alloc]initWithNibName:@"SPCategoryDrivingLicenceViewController" bundle:[NSBundle mainBundle]];
            categoryVC.ObjectDrivingLicence = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 7:
        {
            SPCategoryMembershipViewController *categoryVC = [[SPCategoryMembershipViewController alloc]initWithNibName:@"SPCategoryMembershipViewController" bundle:[NSBundle mainBundle]];
            categoryVC.ObjectMembership = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 8:
        {
            SPCategoryPassportViewController *categoryVC = [[SPCategoryPassportViewController alloc]initWithNibName:@"SPCategoryPassportViewController" bundle:[NSBundle mainBundle]];
            categoryVC.ObjectPassport = [detailArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        default:
            break;
    }
    [[AppData sharedAppData] showAddOnTopOfToolBar];
    
}

#pragma mark - SWRevel tableviewcell datasource
- (NSArray*)leftButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell
{
    return nil;
}
/*- (NSArray*)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell
{
    SWCellButtonItem *btn1 = [SWCellButtonItem itemWithTitle:@"Delete" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        
        NSIndexPath *indexPath = [self.categoryDetailTableView indexPathForCell:cell];
        
        
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Wait!!" message:@"Are you sure you want to Delete?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"No"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                             }];
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  [[AppData sharedAppData] funDeleteCategoryData:self.categoryType recordIDToDelete:[[detailArray objectAtIndex:indexPath.row] valueForKey:@"recordID"]];
                                  [detailArray removeObjectAtIndex:indexPath.row];
                                  
                                  [self.categoryDetailTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                              }];
        [alert addAction:no];
        [alert addAction:yes];
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        UIViewController *topViewController = appdelegate.window.rootViewController;
        while (topViewController.presentedViewController)
        {
            topViewController = topViewController.presentedViewController;
        }
        
        [topViewController presentViewController:alert animated:YES completion:nil];
        
        return true;
    }];
    
    btn1.tintColor = [UIColor whiteColor];
    btn1.backgroundColor = [UIColor redColor];
    btn1.width = 75;
    
    SWCellButtonItem *btn2 = [SWCellButtonItem itemWithTitle:@"Preview" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        
        NSIndexPath *indexPath = [self.categoryDetailTableView indexPathForCell:cell];
        
        SPPreviewViewController *categoryVC = [[SPPreviewViewController alloc]initWithNibName:@"SPPreviewViewController" bundle:[NSBundle mainBundle]];
        categoryVC.previewObject = [detailArray objectAtIndex:indexPath.row];
        categoryVC.categoryType = self.categoryType;
        [self.navigationController pushViewController:categoryVC animated:true];
        
        return true;
    }];
    
    btn2.tintColor = [UIColor whiteColor];
    btn2.backgroundColor = [UIColor magentaColor];
    btn2.width = 75;
    
    return @[btn1,btn2];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
