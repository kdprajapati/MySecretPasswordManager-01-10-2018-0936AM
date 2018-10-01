//
//  SPCategoryDrivingLicenceViewController.h
//  MySecretPasswordManager
//
//  Created by KrishnDip on 07/09/18.
//  Copyright © 2018 nil. All rights reserved.
//
/*
 title
 fullName
 address
 licenceNumber
 classType
 documentNumber
 DOB
 issueDate
 expiryDate
 note
 */
#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"
#import "JSDatePickerCell.h"

@interface SPCategoryDrivingLicenceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate, JSDatePickerCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id ObjectDrivingLicence;

@property (weak, nonatomic) IBOutlet UIScrollView *scrolViewDrivingLicence;

@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtLicenceNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtClassType;
@property (weak, nonatomic) IBOutlet UITextField *txtDocumentNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *DateOfBirthButton;
@property (weak, nonatomic) IBOutlet UIButton *issueDateButton;
@property (weak, nonatomic) IBOutlet UIButton *expiryDateButton;
@property (weak, nonatomic) IBOutlet UIView *onView;

@property (nonatomic) BOOL isFavourite;
@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;

@end
