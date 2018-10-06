//
//  SPCategoryPassportViewController.h
//  MySecretPasswordManager
//
//  Created by KrishnDip on 07/09/18.
//  Copyright © 2018 nil. All rights reserved.
//

/*
 title
 passportType
 issuingCountry
 fullName
 nationality
 issuingAuthority
 DOB
 issueDate
 expiryDate
 note
 */

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"
#import "JSDatePickerCell.h"
#import "NoteViewController.h"

@interface SPCategoryPassportViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate, JSDatePickerCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NoteViewControllerDelegate>

@property (weak, nonatomic) id ObjectPassport;

@property (weak, nonatomic) IBOutlet UIScrollView *scrolViewPassport;

@property (weak, nonatomic) IBOutlet UITextField *txtPassportType;
@property (weak, nonatomic) IBOutlet UITextField *txtIssuingCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtNationality;
@property (weak, nonatomic) IBOutlet UITextField *txtIssuingAuthority;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *DateOfBirthButton;
@property (weak, nonatomic) IBOutlet UIButton *issueDateButton;
@property (weak, nonatomic) IBOutlet UIButton *expiryDateButton;
@property (weak, nonatomic) IBOutlet UIView *onView;

@property (nonatomic) BOOL isFavourite;
@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;

@property (weak, nonatomic) IBOutlet UIButton *noteButton;

@end
