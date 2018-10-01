//
//  SPIdentityViewController.h
//  MySecretPasswordManager
//
//  Created by Nilesh on 4/5/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"

#import "IdentityObject.h"

@interface SPIdentityViewController : UIViewController <SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate,UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IdentityObject *identityObject;
@property (nonatomic) BOOL isFavourite;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewIdentity;
@property (strong, nonatomic) IBOutlet UIView *noteView;

@property (strong, nonatomic) IBOutlet UITextField *txtIdentityTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtOccupation;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtWebsite;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtNote;

@property (strong, nonatomic) IBOutlet UIButton *birthDate;
@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;





@end
