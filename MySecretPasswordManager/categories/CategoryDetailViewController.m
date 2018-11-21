//
//  CategoryDetailViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 24/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "CategoryDetailViewController.h"
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
#import "SPPreviewViewPopupController.h"
#import "AppData.h"
#import "NoDataHelpViewController.h"

@interface CategoryDetailViewController ()
{
    NSMutableArray *detailArray;
    NoDataHelpViewController *noDataHelpVC;
}

@end

@implementation CategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // Do any additional setup after loading the view from its nib.
    self.categoryDetailTableView.delegate = self;
    self.categoryDetailTableView.dataSource = self;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddCaategoryItem)];
    self.navigationItem.rightBarButtonItem = button;
    
//    self.title = [self funGetTitle];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    noDataHelpVC = [[NoDataHelpViewController alloc]initWithNibName:@"NoDataHelpViewController" bundle:[NSBundle mainBundle]];
    noDataHelpVC.view.frame = CGRectMake(0, self.view.center.y, self.view.frame.size.width, 60);
    [self.view addSubview:noDataHelpVC.view];
    noDataHelpVC.view.hidden = true;

    _categoryDetailTableView.hidden = true;
}

-(NSString *)funGetTitle
{
    NSString *titleVC = @"";
    switch (self.categoryType) {
        case 1:
        {
            titleVC = @"Bank Accounts";
        }
            break;
        case 2:
        {
            titleVC = @"Credit Cards";
        }
            break;
        case 3:
        {
            titleVC = @"Login/Passwords";
        }
            break;
        case 4:
        {
            titleVC = @"Identities";
        }
            break;
        case 5:
        {
            titleVC = @"Secure Notes";
        }
            break;
    }
    
    return titleVC;
}

-(void)viewDidAppear:(BOOL)animated
{
//    detailArray = [[CoreDataStackManager sharedManager] funGetDetailObject:self.categoryType];

    detailArray = [[AppData sharedAppData] funGetDetailObject:self.categoryType isFavArrayToReturn:false];
    
    [self.categoryDetailTableView reloadData];
    
    [self funHideShowNoData];
    
    [self.navigationController setToolbarHidden:true animated:true];
    
    [[AppData sharedAppData] showAddAtBottom];
}

-(void)funHideShowNoData
{
    if(detailArray.count > 0)
    {
        noDataHelpVC.view.hidden = true;
        _categoryDetailTableView.hidden = false;
    }
    else
    {
        noDataHelpVC.view.hidden = false;
        _categoryDetailTableView.hidden = true;
    }
}

-(void)AddCaategoryItem
{
    switch (self.categoryType) {
        case 1:
        {
            BankAccountsViewController *categoryVC = [[BankAccountsViewController alloc]initWithNibName:@"SPBankAccountsViewController" bundle:[NSBundle mainBundle]];
            categoryVC.bankObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 2:
        {
            CreditCardViewController *categoryVC = [[CreditCardViewController alloc]initWithNibName:@"SPCreditCardViewController" bundle:[NSBundle mainBundle]];
            categoryVC.ObjectCreditCard = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 3:
        {
            LoginItemsViewController *categoryVC = [[LoginItemsViewController alloc]initWithNibName:@"LoginItemsViewController" bundle:[NSBundle mainBundle]];
            categoryVC.loginObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 4:
        {
            SPIdentityViewController *categoryVC = [[SPIdentityViewController alloc]initWithNibName:@"SPIdentityViewController" bundle:[NSBundle mainBundle]];
            categoryVC.identityObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 5:
        {
            SPSecureNotesViewController *categoryVC = [[SPSecureNotesViewController alloc]initWithNibName:@"SPSecureNotesViewController" bundle:[NSBundle mainBundle]];
            categoryVC.noteObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 6:
        {
            SPCategoryDrivingLicenceViewController *categoryVC = [[SPCategoryDrivingLicenceViewController alloc]initWithNibName:@"SPCategoryDrivingLicenceViewController" bundle:[NSBundle mainBundle]];
//            categoryVC.noteObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 7:
        {
            SPCategoryMembershipViewController *categoryVC = [[SPCategoryMembershipViewController alloc]initWithNibName:@"SPCategoryMembershipViewController" bundle:[NSBundle mainBundle]];
//            categoryVC.noteObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        case 8:
        {
            SPCategoryPassportViewController *categoryVC = [[SPCategoryPassportViewController alloc]initWithNibName:@"SPCategoryPassportViewController" bundle:[NSBundle mainBundle]];
//            categoryVC.noteObject = nil;
            [self.navigationController pushViewController:categoryVC animated:true];
        }
            break;
        default:
            break;
    }
    [[AppData sharedAppData] performSelector:@selector(showAddOnTopOfToolBar) withObject:nil afterDelay:0.5];
//BankAccountsViewController.m
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    SWRevealTableViewCell *cell = [self.categoryDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[SWRevealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    cell.delegate = self;
    cell.dataSource = self;
    cell.cellRevealMode = SWCellRevealModeNormal;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblTitle.text = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    
    switch (self.categoryType) {
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
//            cell.lblSubTitle.text = obj.cardNumber;
        }
            break;
        case 3://Login/Password
        {
            cell.imgView.image = [UIImage imageNamed:@"menu-2.png"];
            cell.lblSubTitle.text = [[detailArray objectAtIndex:indexPath.row] valueForKey:@"username"];
            
        }
            break;
        case 4://Identity
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
    //recordID
    
    switch (self.categoryType) {
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
- (NSArray*)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell
{
    SWCellButtonItem *btn1 = [SWCellButtonItem itemWithTitle:@"Delete" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        
        NSIndexPath *indexPath = [self.categoryDetailTableView indexPathForCell:cell];
        
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to Delete '%@' ?",cell.lblTitle.text];
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Alert!!" message:message preferredStyle:UIAlertControllerStyleAlert];
        
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
                                 
                                 [self funHideShowNoData];
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
    
    /*SWCellButtonItem *btn2 = [SWCellButtonItem itemWithTitle:@"Preview" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        
        NSIndexPath *indexPath = [self.categoryDetailTableView indexPathForCell:cell];

        SPPreviewViewPopupController *categoryVC = [[SPPreviewViewPopupController alloc]initWithNibName:@"SPPreviewViewPopupController" bundle:[NSBundle mainBundle]];
        categoryVC.previewObject = [detailArray objectAtIndex:indexPath.row];
        categoryVC.categoryType = self.categoryType;
        
        [self.navigationController pushViewController:categoryVC animated:true];
//        [self.view.window.rootViewController presentViewController:categoryVC animated:true completion:nil];
        
        return true;
    }];
    
    btn2.tintColor = [UIColor whiteColor];
    btn2.backgroundColor = [UIColor magentaColor];
    btn2.width = 75;*/
    
//    return @[btn1,btn2];
    return @[btn1];
}

@end
