//
//  SPLoginPasswordViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 14/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SPLoginPasswordViewController.h"
#import "MainMenuCellTableViewCell.h"
#import "CoreDataStackManager.h"

@interface SPLoginPasswordViewController ()

@end

@implementation SPLoginPasswordViewController
{
    NSMutableArray *accountFields;
    NSMutableArray *accountKeys;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.scrolViewBankAC.contentSize = CGSizeMake(self.scrolViewBankAC.frame.size.width, self.scrolViewBankAC.frame.size.height+200);
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Login/Password";
    
    accountFields = [[NSMutableArray alloc] init];
    [accountFields addObject:@"Login Name"];
    [accountFields addObject:@"Username"];
    [accountFields addObject:@"Password"];
    [accountFields addObject:@"URL"];
    [accountFields addObject:@"Note"];
    
    accountKeys = [[NSMutableArray alloc] init];
    [accountKeys addObject:@"title"];
    [accountKeys addObject:@"username"];
    [accountKeys addObject:@"url"];
    [accountKeys addObject:@"password"];
    [accountKeys addObject:@"note"];
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveLogin)];
    self.navigationItem.rightBarButtonItem = button;
    
    [self funSetDataToViews];
    
}



-(void)funSetDataToViews
{
    if (self.loginPassObject != nil)
    {
        /*self.txtBankName.text = [self.bankObject valueForKey:@"bankName"];
        self.txtAccountNumber.text = [self.bankObject valueForKey:@"accountNumber"];
        self.txtAccountHolderName.text = [self.bankObject valueForKey:@"accountHolderName"];
        self.txtAccountType.text = [self.bankObject valueForKey:@"accountType"];
        self.txtAccountType.text = [self.bankObject valueForKey:@"accountPIN"];
        self.txtBranchCode.text = [self.bankObject valueForKey:@"branchCode"];
        self.txtBranchPhone.text = [self.bankObject valueForKey:@"branchPhone"];
        self.txtBranchAddress.text = [self.bankObject valueForKey:@"branchAddress"];
        self.txtNote.text = [self.bankObject valueForKey:@"note"];*/
    }
}

-(void)AddSaveBankAccount123
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //    pasteboard.string = [NSString stringWithFormat:@""];
    NSString *myString = @"Hello";
    NSString *myOtherString = @"again";
    NSString *myalphanumeric = @"a3454";
    NSString *myname = @"name : karan ";
    NSString *mytes = @"symbols √Ωåß∑´†¥ ";
    NSArray *stringArray = @[myString, myOtherString,myalphanumeric,myname,mytes];
    
    pasteboard.strings = stringArray;
}

-(void)AddSaveLogin
{
    NSManagedObjectContext *context = [[CoreDataStackManager sharedManager] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BankAccount" inManagedObjectContext:context];
    NSManagedObject *object;
    
    
    if (self.loginPassObject != nil)
    {
        NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"BankAccount"];
        req.predicate= [NSPredicate predicateWithFormat:@"recordID == %@",[self.loginPassObject valueForKey:@"recordID"]];
        NSArray *objectArray = [context executeFetchRequest:req error:nil];
        if (objectArray != nil && objectArray.count > 0)
        {
            object = [objectArray objectAtIndex:0];
        }
    }
    else
    {
        object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        [object setValue:[[CoreDataStackManager sharedManager] funGenerateUDID] forKey:@"recordID"];
    }
    
    NSMutableArray *arrayDetail = [[NSMutableArray alloc] init];
    
    int i=0;
    
    /*[object setValue:self.txtBankName.text forKey:@"title"];
    [object setValue:self.txtBankName.text forKey:@"bankName"];
    [object setValue:self.txtAccountNumber.text forKey:@"accountNumber"];
    [object setValue:self.txtAccountHolderName.text forKey:@"accountHolderName"];
    [object setValue:self.txtAccountType.text forKey:@"accountType"];
    [object setValue:self.txtPIN.text forKey:@"accountPIN"];
    [object setValue:self.txtBranchCode.text forKey:@"branchCode"];
    [object setValue:self.txtBranchPhone.text forKey:@"branchPhone"];
    [object setValue:self.txtBranchAddress.text forKey:@"branchAddress"];
    [object setValue:self.txtNote.text forKey:@"note"];*/
    
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
