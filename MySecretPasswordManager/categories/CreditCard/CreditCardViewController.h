//
//  CreditCardViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 06/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SWRevealTableViewCell.h"
#import "JSDatePickerCell.h"
#import "CreditCardObject.h"
#import "NoteViewController.h"

@interface CreditCardViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate, JSDatePickerCellDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NoteViewControllerDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *creditCardTableView;

@property (weak, nonatomic) NSManagedObject *creditCardObject;
//@property (weak, nonatomic) CreditCardObject *ObjectCreditCard;
@property (weak, nonatomic) id ObjectCreditCard;

@property (weak, nonatomic) IBOutlet UIScrollView *scrolViewCreditCard;

@property (weak, nonatomic) IBOutlet UITextField *txtBankName;
@property (weak, nonatomic) IBOutlet UITextField *txtCardHolderName;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtCardType;
@property (weak, nonatomic) IBOutlet UITextField *txtCardPIN;
@property (weak, nonatomic) IBOutlet UITextField *txtLocalPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtTollFree;
@property (weak, nonatomic) IBOutlet UITextField *txtWebsite;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *expiryDateButton;
@property (weak, nonatomic) IBOutlet UIButton *validFromButton;
@property (weak, nonatomic) IBOutlet UIView *onView;

@property (nonatomic) BOOL isFavourite;
@property (strong, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;

@property (weak, nonatomic) IBOutlet UIButton *noteButton;

@property (weak, nonatomic) IBOutlet UIButton *showHidePinBtn;
@end
