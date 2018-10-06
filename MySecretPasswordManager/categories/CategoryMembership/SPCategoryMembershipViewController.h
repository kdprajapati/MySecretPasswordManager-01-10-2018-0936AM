//
//  SPCategoryMembershipViewController.h
//  MySecretPasswordManager
//
//  Created by KrishnDip on 07/09/18.
//  Copyright © 2018 nil. All rights reserved.
//
/*
 title
 groupName
 website
 telephone
 memberName
 memberSinceDate
 expiryDate
 memberID
 memberPassword
 note
 */
#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"
#import "JSDatePickerCell.h"
#import "NoteViewController.h"

@interface SPCategoryMembershipViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate, JSDatePickerCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NoteViewControllerDelegate>

@property (weak, nonatomic) id ObjectMembership;

@property (weak, nonatomic) IBOutlet UIScrollView *scrolViewMembership;

@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
@property (weak, nonatomic) IBOutlet UITextField *txtWebsite;
@property (weak, nonatomic) IBOutlet UITextField *txtTelephone;
@property (weak, nonatomic) IBOutlet UITextField *txtMemberName;
@property (weak, nonatomic) IBOutlet UITextField *txtMemberID;
@property (weak, nonatomic) IBOutlet UITextField *txtMemberPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *memberSinceDateButton;
@property (weak, nonatomic) IBOutlet UIButton *expiryDateButton;
@property (weak, nonatomic) IBOutlet UIView *onView;

@property (nonatomic) BOOL isFavourite;
@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;

@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@end
