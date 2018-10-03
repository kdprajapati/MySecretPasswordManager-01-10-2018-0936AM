//
//  BankAccountsViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 24/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SWRevealTableViewCell.h"

#import "BankAccountObject.h"
#import "NoteViewController.h"

@interface BankAccountsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate,UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, NoteViewControllerDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *bankAccountDetailTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolViewBankAC;

@property (weak, nonatomic) BankAccountObject *bankObject;

@property (weak, nonatomic) IBOutlet UITextField *txtBankName;
@property (weak, nonatomic) IBOutlet UITextField *txtAccountNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAccountHolderName;
@property (weak, nonatomic) IBOutlet UITextField *txtAccountType;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;


@property (weak, nonatomic) IBOutlet UITextField *txtPIN;
@property (weak, nonatomic) IBOutlet UITextField *txtBranchCode;
@property (weak, nonatomic) IBOutlet UITextField *txtBranchPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtBranchAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *showHidePinBtn;
@property (weak, nonatomic) IBOutlet UIView *onView;

@property (nonatomic) BOOL isFavourite;
@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;

@end
