//
//  PreviewNewViewController.m
//  MySecretPasswordManager
//
//  Created by Nilesh on 5/28/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "PreviewNewViewController.h"

@interface PreviewNewViewController ()
{
    NSMutableArray *previewKeyArray;
    NSMutableArray *previewItemsArray;
}
@end

@implementation PreviewNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.buttonShareNow.layer.cornerRadius = 4.0;
    
    self.previewTableView.delegate = self;
    self.previewTableView.dataSource = self;
    [self.previewTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    previewItemsArray = [[NSMutableArray alloc] init];
    previewKeyArray = [[NSMutableArray alloc] init];
    
    [self funSetupPreviewArray];
}

-(void)funSetupPreviewArray
{
    switch (self.categoryType) {
        case 1:
        {
            [self funSetBankAccountInfoToArray];
        }
            break;
        case 2:
        {
            [self funSetCreditCardInfoToArray];
        }
            break;
        case 3:
        {
            [self funSetLoginPasswrodInfoToArray];
        }
            break;
        case 4:
        {
            [self funSetIdentityInfoToArray];
        }
            break;
        case 5:
        {
            [self funSetSecureNoteInfoToArray];
        }
            break;
        case 6:
        {
            [self funSetDrivingLicenceInfoToArray];
        }
            break;
        case 7:
        {
            [self funSetMembershipInfoToArray];
        }
            break;
        case 8:
        {
            [self funSetPassportInfoToArray];
        }
            break;
        default:
            break;
    }
}

#pragma mark - category info to Array
-(void)funSetBankAccountInfoToArray
{
    NSString *bankName = [self.previewObject valueForKey:@"bankName"];
    NSString *acNumber = [self.previewObject valueForKey:@"accountNumber"];
    NSString *acHolderName = [self.previewObject valueForKey:@"accountHolderName"];
    NSString *acType = [self.previewObject valueForKey:@"accountType"];
    NSString *userID = [self.previewObject valueForKey:@"userID"];
    NSString *branchCode = [self.previewObject valueForKey:@"branchCode"];
    NSString *branchName = [self.previewObject valueForKey:@"branchPhone"];
    NSString *branchAdd = [self.previewObject valueForKey:@"branchAddress"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (bankName != nil)
    {
        [previewItemsArray addObject:bankName];
        [previewKeyArray addObject:@"Bank Name"];
    }
    
    if (acNumber != nil)
    {
        [previewItemsArray addObject:acNumber];
        [previewKeyArray addObject:@"Account Number"];
    }
    
    if (acHolderName != nil)
    {
        [previewItemsArray addObject:acHolderName];
        [previewKeyArray addObject:@"Account Holder Name"];
    }
    
    if (acType != nil)
    {
        [previewItemsArray addObject:acType];
        [previewKeyArray addObject:@"ACcount Type"];
    }
    
    if (userID != nil)
    {
        [previewItemsArray addObject:userID];
        [previewKeyArray addObject:@"User ID"];
    }
    
    if (branchCode != nil)
    {
        [previewItemsArray addObject:branchCode];
        [previewKeyArray addObject:@"Branch Code"];
    }
    
    if (branchName != nil)
    {
        [previewItemsArray addObject:branchName];
        [previewKeyArray addObject:@"Branch Name"];
    }
    
    if (branchAdd != nil)
    {
        [previewItemsArray addObject:branchAdd];
        [previewKeyArray addObject:@"Branch Address"];
    }
    
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }

}

-(void)funSetCreditCardInfoToArray
{
    
    NSString *bankName = [self.previewObject valueForKey:@"bankName"];
    NSString *cardHolderName = [self.previewObject valueForKey:@"cardHolderName"];
    NSString *cardNumber = [self.previewObject valueForKey:@"cardNumber"];
    NSString *cardType = [self.previewObject valueForKey:@"cardType"];
    NSString *localPhone = [self.previewObject valueForKey:@"localPhone"];
    NSString *tollFreePhone = [self.previewObject valueForKey:@"tollFreePhone"];
    NSString *website = [self.previewObject valueForKey:@"website"];
    NSString *expiryDate = [self.previewObject valueForKey:@"expiryDate"];
    NSString *validFrom = [self.previewObject valueForKey:@"validFrom"];
    
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    
    if (bankName != nil)
    {
        [previewItemsArray addObject:bankName];
        [previewKeyArray addObject:@"Bank Name"];
    }
    if (cardHolderName != nil)
    {
        [previewItemsArray addObject:cardHolderName];
        [previewKeyArray addObject:@"Card Holder Name"];
    }
    if (cardNumber != nil)
    {
        [previewItemsArray addObject:cardNumber];
        [previewKeyArray addObject:@"Card Number"];
    }
    if (cardType != nil)
    {
        [previewItemsArray addObject:cardType];
        [previewKeyArray addObject:@"Card Type"];
    }
    if (localPhone != nil)
    {
        [previewItemsArray addObject:localPhone];
        [previewKeyArray addObject:@"Local Phone"];
    }
    if (tollFreePhone != nil)
    {
        [previewItemsArray addObject:tollFreePhone];
        [previewKeyArray addObject:@"Toll Free"];
    }
    if (website != nil)
    {
        [previewItemsArray addObject:website];
        [previewKeyArray addObject:@"Website"];
    }
    if (expiryDate != nil)
    {
        [previewItemsArray addObject:expiryDate];
        [previewKeyArray addObject:@"Expiry Date"];
    }
    if (validFrom != nil)
    {
        [previewItemsArray addObject:validFrom];
        [previewKeyArray addObject:@"Valid From"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

-(void)funSetLoginPasswrodInfoToArray
{
    NSString *loginName = [self.previewObject valueForKey:@"loginName"];
    NSString *url = [self.previewObject valueForKey:@"url"];
    NSString *username = [self.previewObject valueForKey:@"username"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (loginName != nil)
    {
        [previewItemsArray addObject:loginName];
        [previewKeyArray addObject:@"Login Name"];
    }
    if (url != nil)
    {
        [previewItemsArray addObject:url];
        [previewKeyArray addObject:@"URL/Website"];
    }
    if (username != nil)
    {
        [previewItemsArray addObject:username];
        [previewKeyArray addObject:@"Username"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

-(void)funSetIdentityInfoToArray
{
    NSString *firstName = [self.previewObject valueForKey:@"firstName"];
    NSString *lastName = [self.previewObject valueForKey:@"lastName"];
    NSString *email = [self.previewObject valueForKey:@"email"];
    NSString *occupation = [self.previewObject valueForKey:@"occupation"];
    NSString *phoneNumber = [self.previewObject valueForKey:@"phoneNumber"];
    NSString *webSite = [self.previewObject valueForKey:@"webSite"];
    NSString *address = [self.previewObject valueForKey:@"address"];
    NSString *country = [self.previewObject valueForKey:@"country"];
    NSString *birthDate = [self.previewObject valueForKey:@"birthDate"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (firstName != nil)
    {
        [previewItemsArray addObject:firstName];
        [previewKeyArray addObject:@"First Name"];
    }
    if (lastName != nil)
    {
        [previewItemsArray addObject:lastName];
        [previewKeyArray addObject:@"Last Name"];
    }
    if (email != nil)
    {
        [previewItemsArray addObject:email];
        [previewKeyArray addObject:@"Personal Email"];
    }
    if (occupation != nil)
    {
        [previewItemsArray addObject:occupation];
        [previewKeyArray addObject:@"Occupation"];
    }
    if (phoneNumber != nil)
    {
        [previewItemsArray addObject:phoneNumber];
        [previewKeyArray addObject:@"Phone Number"];
    }
    if (webSite != nil)
    {
        [previewItemsArray addObject:webSite];
        [previewKeyArray addObject:@"Website"];
    }
    if (address != nil)
    {
        [previewItemsArray addObject:address];
        [previewKeyArray addObject:@"Address"];
    }
    if (country != nil)
    {
        [previewItemsArray addObject:country];
        [previewKeyArray addObject:@"Country"];
    }
    if (birthDate != nil)
    {
        [previewItemsArray addObject:birthDate];
        [previewKeyArray addObject:@"Birth date"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

-(void)funSetSecureNoteInfoToArray
{
    NSString *title = [self.previewObject valueForKey:@"title"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (title != nil)
    {
        [previewItemsArray addObject:title];
        [previewKeyArray addObject:@"Note Title"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

-(void)funSetDrivingLicenceInfoToArray
{
    
    NSString *fullName = [self.previewObject valueForKey:@"fullName"];
    NSString *address = [self.previewObject valueForKey:@"address"];
    NSString *licenceNumber = [self.previewObject valueForKey:@"licenceNumber"];
    NSString *classType = [self.previewObject valueForKey:@"classType"];
    NSString *documentNumber = [self.previewObject valueForKey:@"documentNumber"];
    NSString *DOB = [self.previewObject valueForKey:@"DOB"];
    NSString *issueDate = [self.previewObject valueForKey:@"issueDate"];
    NSString *expiryDate = [self.previewObject valueForKey:@"expiryDate"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (fullName != nil)
    {
        [previewItemsArray addObject:fullName];
        [previewKeyArray addObject:@"Full Name"];
    }
    if (address != nil)
    {
        [previewItemsArray addObject:address];
        [previewKeyArray addObject:@"Address"];
    }
    if (licenceNumber != nil)
    {
        [previewItemsArray addObject:licenceNumber];
        [previewKeyArray addObject:@"Licence Number"];
    }
    if (classType != nil)
    {
        [previewItemsArray addObject:classType];
        [previewKeyArray addObject:@"Licence Type"];
    }
    if (documentNumber != nil)
    {
        [previewItemsArray addObject:documentNumber];
        [previewKeyArray addObject:@"Document Number"];
    }
    if (DOB != nil)
    {
        [previewItemsArray addObject:DOB];
        [previewKeyArray addObject:@"Date Of Birth"];
    }
    if (issueDate != nil)
    {
        [previewItemsArray addObject:issueDate];
        [previewKeyArray addObject:@"Issue Date"];
    }
    if (expiryDate != nil)
    {
        [previewItemsArray addObject:expiryDate];
        [previewKeyArray addObject:@"Expiry date"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

-(void)funSetMembershipInfoToArray
{
    NSString *memberName = [self.previewObject valueForKey:@"memberName"];
    NSString *memberID = [self.previewObject valueForKey:@"memberID"];
    NSString *groupName = [self.previewObject valueForKey:@"groupName"];
    NSString *telephone = [self.previewObject valueForKey:@"telephone"];
    NSString *website = [self.previewObject valueForKey:@"website"];
    NSString *memberSinceDate = [self.previewObject valueForKey:@"memberSinceDate"];
    NSString *expiryDate = [self.previewObject valueForKey:@"expiryDate"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (memberName != nil)
    {
        [previewItemsArray addObject:memberName];
        [previewKeyArray addObject:@"Member Name"];
    }
    if (memberID != nil)
    {
        [previewItemsArray addObject:memberID];
        [previewKeyArray addObject:@"Member ID"];
    }
    if (groupName != nil)
    {
        [previewItemsArray addObject:groupName];
        [previewKeyArray addObject:@"Group Name"];
    }
    if (telephone != nil)
    {
        [previewItemsArray addObject:telephone];
        [previewKeyArray addObject:@"Telephone"];
    }
    if (website != nil)
    {
        [previewItemsArray addObject:website];
        [previewKeyArray addObject:@"Website"];
    }
    if (memberSinceDate != nil)
    {
        [previewItemsArray addObject:memberSinceDate];
        [previewKeyArray addObject:@"Member Since Date"];
    }
    if (expiryDate != nil)
    {
        [previewItemsArray addObject:expiryDate];
        [previewKeyArray addObject:@"Expiry Date"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

-(void)funSetPassportInfoToArray
{
    NSString *firstName = [self.previewObject valueForKey:@"firstName"];
    NSString *lastName = [self.previewObject valueForKey:@"lastName"];
    NSString *email = [self.previewObject valueForKey:@"email"];
    NSString *occupation = [self.previewObject valueForKey:@"occupation"];
    NSString *phoneNumber = [self.previewObject valueForKey:@"phoneNumber"];
    NSString *webSite = [self.previewObject valueForKey:@"webSite"];
    NSString *address = [self.previewObject valueForKey:@"address"];
    NSString *country = [self.previewObject valueForKey:@"country"];
    NSString *birthDate = [self.previewObject valueForKey:@"birthDate"];
    NSString *note = [self.previewObject valueForKey:@"note"];
    
    if (firstName != nil)
    {
        [previewItemsArray addObject:firstName];
        [previewKeyArray addObject:@"First Name"];
    }
    if (lastName != nil)
    {
        [previewItemsArray addObject:lastName];
        [previewKeyArray addObject:@"Last Name"];
    }
    if (email != nil)
    {
        [previewItemsArray addObject:email];
        [previewKeyArray addObject:@"Personal Email"];
    }
    if (occupation != nil)
    {
        [previewItemsArray addObject:occupation];
        [previewKeyArray addObject:@"Occupation"];
    }
    if (phoneNumber != nil)
    {
        [previewItemsArray addObject:phoneNumber];
        [previewKeyArray addObject:@"Phone Number"];
    }
    if (webSite != nil)
    {
        [previewItemsArray addObject:webSite];
        [previewKeyArray addObject:@"Website"];
    }
    if (address != nil)
    {
        [previewItemsArray addObject:address];
        [previewKeyArray addObject:@"Address"];
    }
    if (country != nil)
    {
        [previewItemsArray addObject:country];
        [previewKeyArray addObject:@"Country"];
    }
    if (birthDate != nil)
    {
        [previewItemsArray addObject:birthDate];
        [previewKeyArray addObject:@"Birth date"];
    }
    if (note != nil)
    {
        [previewItemsArray addObject:note];
        [previewKeyArray addObject:@"Note"];
    }
    
}

- (IBAction)funSharePreview:(id)sender {
    
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(self.previewTableView.contentSize);
    {
        CGPoint savedContentOffset = self.previewTableView.contentOffset;
        CGRect savedFrame = self.previewTableView.frame;
        
        self.previewTableView.contentOffset = CGPointZero;
        self.previewTableView.frame = CGRectMake(0, 0, self.previewTableView.contentSize.width, self.previewTableView.contentSize.height);
        
        [self.previewTableView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.previewTableView.contentOffset = savedContentOffset;
        self.previewTableView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    /*if (image != nil) {
        [UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
    }*/
    
    NSArray *activityItems = [NSArray arrayWithObjects:image, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
#pragma  mark :- tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return previewItemsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringPreview = [previewItemsArray objectAtIndex:indexPath.row];
    if (stringPreview != nil && stringPreview.length > 0)
    {
//        return 50;
        return UITableViewAutomaticDimension;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.previewTableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *stringPreview = [previewItemsArray objectAtIndex:indexPath.row];
    if (stringPreview != nil && stringPreview.length > 0)
    {
        cell.textLabel.text = [previewKeyArray objectAtIndex:indexPath.row];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.minimumScaleFactor = 7.0;
        
        cell.detailTextLabel.text = [previewItemsArray objectAtIndex:indexPath.row];
//        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = true;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1.0];
        cell.detailTextLabel.minimumScaleFactor = 7.0;
        return cell;
    }
    
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
