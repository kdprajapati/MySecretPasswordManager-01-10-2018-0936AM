//
//  CreditCardViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 06/01/18.
//  Copyright © 2018 nil. All rights reserved.
//
#import "SPPreviewViewPopupController.h"
#import "CreditCardViewController.h"
#import "MainMenuCellTableViewCell.h"
#import "CoreDataStackManager.h"
#import "AppData.h"
#import "protocol.h"
#import "HorizontalScrollCell.h"
#import "PreviewNewViewController.h"
#import "ImageShowViewController.h"

#import "MySecretPasswordManager-Swift.h"

@interface CreditCardViewController ()

@end

@implementation CreditCardViewController

{
    NSMutableArray *accountFields;
    NSMutableArray *accountKeys;
    NSIndexPath *selectedIndexPath;
    UIDatePicker *datePicker;
    int dateViewTag;
    CGFloat scrollViewHeight;
    
    NSString *recordIDCategory;
    NSMutableArray *images;
    NSMutableArray *imagePathsArray;
    
    BOOL isSavedData;
    UILabel *noImageYetLabel;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Credit Card";
    // Do any additional setup after loading the view from its nib.
    CGFloat contentRatio = ([UIScreen mainScreen].bounds.size.height*230)/320;
    self.scrolViewCreditCard.contentSize = CGSizeMake(self.scrolViewCreditCard.frame.size.width, self.onView.frame.size.height * 15.5 + 50);
    NSLog(@"self.scrolViewCreditCard.contentSize - %@",NSStringFromCGSize(self.scrolViewCreditCard.contentSize));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.title = @"Credit Card";
    
    
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveCreditCard)];
    //
    //    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    
    selectedIndexPath = [[NSIndexPath alloc] init];
    
    [self funAllocBottomBarButtons];
    
    [self funSetDataToViews];
    
    //    [self funCreateDataPicker];
    datePicker = [[UIDatePicker alloc] init];
    
    self.txtBankName.delegate = self;
    self.txtCardHolderName.delegate = self;
    self.txtCardNumber.delegate = self;
    self.txtCardType.delegate = self;
    self.txtCardPIN.delegate = self;
    self.txtLocalPhone.delegate = self;
    self.txtTollFree.delegate = self;
    self.txtWebsite.delegate = self;
    self.txtNote.delegate = self;
    
    scrollViewHeight = _scrolViewCreditCard.frame.size.height;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    noImageYetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.collectionViewPhotos.frame.size.width, 44)];
    noImageYetLabel.text = @"No Photos Yet!";
    noImageYetLabel.textAlignment = NSTextAlignmentCenter;
    noImageYetLabel.center = self.collectionViewPhotos.center;
    [self.collectionViewPhotos addSubview:noImageYetLabel];
    noImageYetLabel.hidden = true;
    
    [self prepareImages];
    
    [self setUpCollection];
    
    if (self.creditCardObject == nil)
    {
        [self funChangeRighBarButtonItemEditSave:false];
    }
    else
    {
        [self funChangeRighBarButtonItemEditSave:true];
    }
    
}

/**
 add bottom bar buttons - favourite and settings
 */
-(void)funAllocBottomBarButtons
{
    
    UIBarButtonItem *flexibalSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.favouriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
    [self.favouriteBtn addTarget:self action:@selector(funDoFavourite) forControlEvents:UIControlEventTouchUpInside];
    self.favouriteBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIBarButtonItem *favouriteBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.favouriteBtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [shareBtn setImage:[UIImage imageNamed:@"share_normal.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(funPreviewShare:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    UIBarButtonItem *shareBtnBar = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [deleteBtn setImage:[UIImage imageNamed:@"delete_normal.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(funDeleteObject:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteBtnBar = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    
    self.navigationController.toolbarHidden = false;
    
    self.toolbarItems = [NSArray arrayWithObjects: favouriteBarBtn,flexibalSpace, shareBtnBar,flexibalSpace, deleteBtnBar, nil];
    
    
}

-(void)funChangeRighBarButtonItemEditSave:(BOOL)isEdit
{
    if (isEdit)
    {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(EditCategory)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: editButton, nil];
        
        [self funSetInteractionFalseToAllTextfields];
    }
    else
    {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveCreditCard)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.scrolViewCreditCard.contentSize = CGSizeMake(self.scrolViewCreditCard.frame.size.width, self.onView.frame.size.height * 15.5 + 50);
    [self.navigationController setToolbarHidden:false animated:true];
    
    [[AppData sharedAppData] showAddOnTopOfToolBar];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isBeingDismissed] || [self isMovingFromParentViewController])
    {
        if (isSavedData == false)
        {
            NSString *filePath = [[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryBankAccount recordID:recordIDCategory];
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            NSLog(@"error deleting photo - %@",error);
        }
    }
}

-(void)cellSelected:(UIImage *)image
{
    ImageShowViewController *imageShowVC = [[ImageShowViewController alloc]initWithNibName:@"ImageShowViewController" bundle:[NSBundle mainBundle]];
    imageShowVC.imageDetail = image;
    [self.navigationController pushViewController:imageShowVC animated:true];
}

- (IBAction)funAddPhotos:(id)sender {
    [self funShowCameraOptions];
}

-(void)funShowCameraOptions
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Choose Option" message:@"Get Photo from below options" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self funOpenPhotoLibrary];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self funOpenCamera];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)funOpenCamera
{
    UIImagePickerController *picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    picker2.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker2 animated:YES completion:NULL];
}

-(void)funOpenPhotoLibrary
{
    UIImagePickerController *picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    picker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker2 animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    int i;
    AppData *appData = [AppData sharedAppData];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    NSString *filePath = [appData funGetCategoryRecordIDDirectory:KCategoryCreditCard recordID:recordIDCategory];
    NSArray *arrayFileCount = [appData getListOfDirectoryOfCategoryType:KCategoryCreditCard recordID:recordIDCategory];
    i=arrayFileCount.count;
    
    //get full path
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%lu.png",(unsigned long)i]];
    
    //create directory
    [appData funCreateCategoryPhotosForRecordId:KCategoryCreditCard recordID:recordIDCategory];
    
    [pngData writeToFile:filePath atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self funUpdateCollectionPhotos];
    }];
    
}

-(void)viewDidLayoutSubviews
{
    noImageYetLabel.frame = CGRectMake(0, self.collectionViewPhotos.frame.size.height/2 - 22, self.view.frame.size.width - 8, 44);
}

-(void)prepareImages
{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSArray *arrayListFiles = [[AppData sharedAppData] getListOfDirectoryOfCategoryType:KCategoryCreditCard recordID:recordIDCategory];
    
    if (imagePathsArray != nil)
    {
        [imagePathsArray removeAllObjects];
    }
    else
    {
        imagePathsArray = [[NSMutableArray alloc] init];
    }
    
    for(int i = 0; i < arrayListFiles.count; i++)
    {
        NSString *fileName = [arrayListFiles objectAtIndex:i];
        NSString *filePath = [[[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryCreditCard recordID:recordIDCategory] stringByAppendingPathComponent:fileName];
        [imagePathsArray addObject:filePath];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        if (image != nil)
        {
            [tmp addObject:image];
        }
        
    }
    
    if (images != nil)
    {
        [images removeAllObjects];
    }
    else
    {
        images = [[NSMutableArray alloc] init];
    }
    [images addObjectsFromArray:tmp];
    
    if (arrayListFiles.count > 0)
    {
        noImageYetLabel.hidden = true;
    }
    else
    {
        noImageYetLabel.hidden = false;
    }
}

-(void)setUpCollection
{
    self.collectionViewPhotos.layer.cornerRadius = 4.0;
    self.collectionViewPhotos.layer.borderWidth = 1.0;
    self.collectionViewPhotos.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.collectionViewPhotos.delegate = self;
    self.collectionViewPhotos.dataSource = self;
    
    UINib *hsCellNib = [UINib nibWithNibName:@"HorizontalScrollCell" bundle:nil];
    [self.collectionViewPhotos registerNib:hsCellNib forCellWithReuseIdentifier:@"cvcHsc"];
    
    [self.collectionViewPhotos reloadData];
}


- (IBAction)funDeleteObject:(id)sender
{
    NSString *recordID = [self.ObjectCreditCard valueForKey:@"recordID"];
    if (recordID != nil && ![recordID isEqualToString:@""])
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Alert!!" message:@"Are you sure you want to Delete?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"No"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                             }];
        UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Yes"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategoryCreditCard recordIDToDelete:recordID];
                                  
                                  [self.navigationController popViewControllerAnimated:true];
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
    }
    
}

- (IBAction)funPreviewShare:(id)sender
{
    //    SPPreviewViewPopupController *categoryVC = [[SPPreviewViewPopupController alloc]initWithNibName:@"SPPreviewViewPopupController" bundle:[NSBundle mainBundle]];
    PreviewNewViewController *categoryVC = [[PreviewNewViewController alloc]initWithNibName:@"PreviewNewViewController" bundle:[NSBundle mainBundle]];
    
    categoryVC.previewObject = [self funReturnCurrentObjectForPreview];
    categoryVC.categoryType = KCategoryCreditCard;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}



//Horizontalscroll cell delegate method
-(void)funRemoveImage:(int)tag
{
    NSString *imageToDeletePath = [imagePathsArray objectAtIndex:tag];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imageToDeletePath error:&error];
    NSLog(@"error deleting photo - %@",error);
    
    [self performSelector:@selector(funUpdateCollectionPhotos) withObject:nil afterDelay:0.5];
}

-(void)funUpdateCollectionPhotos
{
    [self prepareImages];
    [self.collectionViewPhotos reloadData];
}

#pragma mark:- keyboard notifications
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewCreditCard.frame = CGRectMake(_scrolViewCreditCard.frame.origin.x, _scrolViewCreditCard.frame.origin.y, _scrolViewCreditCard.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewCreditCard.frame = CGRectMake(_scrolViewCreditCard.frame.origin.x, _scrolViewCreditCard.frame.origin.y, _scrolViewCreditCard.frame.size.width, _scrolViewCreditCard.frame.size.height + keyboardFrame.size.height);
}

- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}

-(void)funDoFavourite
{
    if (self.txtBankName.text.length == 0 && self.txtCardNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtCardNumber.layer.borderWidth = 1.0;
        self.txtCardNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtBankName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtCardNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtCardNumber.layer.borderWidth = 1.0;
        self.txtCardNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    else
    {
        if (self.isFavourite == true)
        {
            self.isFavourite = false;
            [self.favouriteBtn setSelected:false];
            [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            self.isFavourite = true;
            [self.favouriteBtn setSelected:true];
            [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateNormal];
        }
        
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f", keyboardHeight);
    
}

-(void)funCreateDatePicker
{
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker addTarget:self action:@selector(funDatePicked) forControlEvents:UIControlEventValueChanged];
    
    UIAlertController *dateAlert = [UIAlertController alertControllerWithTitle:@"Choose Date" message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [dateAlert addAction:closeAction];
    [dateAlert.view addSubview:datePicker];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //Adjust the popover Frame to appear where I want
        CGRect senderFrame;//= sender.frame;//CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 320,     200);
        
        if (dateViewTag == 5)
        {
            senderFrame = _expiryDateButton.frame;
        }
        else
        {
            senderFrame = _validFromButton.frame;
        }
        
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:dateAlert];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        
        [self presentViewController:dateAlert animated:true completion:nil];
    }
}

- (IBAction)funExpiryDateClicked:(id)sender
{
    [self funCreateDatePicker];
    dateViewTag = 5;
}

- (IBAction)funValidFromDateClicked:(id)sender
{
    [self funCreateDatePicker];
    dateViewTag = 8;
}


-(void)funDatePicked
{
    NSDate *pickedDate = [datePicker date];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    formatter.dateStyle = kCFDateFormatterShortStyle;
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *stringDate = [formatter stringFromDate:pickedDate]; //[NSString stringWithFormat:@"%@",pickedDate];
    
    switch (dateViewTag) {
        case 5:
            [self.expiryDateButton setTitle:stringDate forState:UIControlStateNormal];
            [self.ObjectCreditCard setValue:pickedDate forKey:@"expiryDate"];
            break;
        case 8:
            [self.validFromButton setTitle:stringDate forState:UIControlStateNormal];
            [self.ObjectCreditCard setValue:pickedDate forKey:@"validFrom"];
            break;
            
        default:
            break;
    }
}

- (IBAction)funOpenNoteView:(id)sender {
    NoteViewController *noteVC = [[NoteViewController alloc]initWithNibName:@"NoteViewController" bundle:[NSBundle mainBundle]];
    noteVC.delegate = self;
    noteVC.buttonText = self.noteButton.titleLabel.text;
    [self.navigationController pushViewController:noteVC animated:true];
}

//Note view delegate
-(void)funNoteTextForCategory:(NSString *)text
{
    [self.noteButton setTitle:text forState:UIControlStateNormal];
}

#pragma mark :- save / Set data methods
-(void)funSetDataToViews
{
    if (self.ObjectCreditCard != nil)
    {
        self.txtCardPIN.secureTextEntry = true;
        
        NSString *decCardPIN = [[AppData sharedAppData] decrypt:[self.ObjectCreditCard valueForKey:@"cardPIN"] withKey:[AppData sharedAppData].userAppPassword];
        
        self.txtBankName.text = [self.ObjectCreditCard valueForKey:@"bankName"];
        self.self.txtCardHolderName.text = [self.ObjectCreditCard valueForKey:@"cardHolderName"];
        self.txtCardNumber.text = [self.ObjectCreditCard valueForKey:@"cardNumber"];
        self.txtCardType.text = [self.ObjectCreditCard valueForKey:@"cardType"];
        if (decCardPIN != nil)
        {
            self.txtCardPIN.text = decCardPIN;
        }
        self.txtLocalPhone.text = [self.ObjectCreditCard valueForKey:@"localPhone"];
        self.txtTollFree.text = [self.ObjectCreditCard valueForKey:@"tollFreePhone"];
        self.txtWebsite.text = [self.ObjectCreditCard valueForKey:@"website"];
        //        self.txtNote.text = [self.ObjectCreditCard valueForKey:@"note"];
        if ([self.ObjectCreditCard valueForKey:@"note"] != nil)
        {
            [self.noteButton setTitle:[self.ObjectCreditCard valueForKey:@"note"] forState:UIControlStateNormal];
        }
        else{
            [self.noteButton setTitle:[self.ObjectCreditCard valueForKey:@"Tap to create note"] forState:UIControlStateNormal];
        }
        
        NSLog(@"expirydate- %@",[self.ObjectCreditCard valueForKey:@"expiryDate"]);
        NSLog(@"validFrom date- %@",[self.ObjectCreditCard valueForKey:@"validFrom"]);
        
        NSString *expiryDate = (NSString *)[self.ObjectCreditCard valueForKey:@"expiryDate"];
        
        if (expiryDate != nil)
        {
            [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",expiryDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",expiryDate] forState:UIControlStateNormal];
        }
        
        id validDate = [self.ObjectCreditCard valueForKey:@"validFrom"];
        if (validDate != nil)
        {
            [self.validFromButton setTitle:[NSString stringWithFormat:@"%@",validDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.validFromButton setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
        
        self.isFavourite = [[self.ObjectCreditCard valueForKey:@"isFavourite"] boolValue];
        
        if (self.isFavourite == true)
        {
            self.isFavourite = true;
            [self.favouriteBtn setSelected:true];
            [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateNormal];
        }
        else
        {
            self.isFavourite = false;
            [self.favouriteBtn setSelected:false];
            [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [NSDate date];
        
        [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
        [self.validFromButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
    }
    
    if (self.ObjectCreditCard != nil)
    {
        recordIDCategory = [self.ObjectCreditCard valueForKey:@"recordID"];
        isSavedData = true;
    }
    else
    {
        recordIDCategory = [[AppData sharedAppData] funGenerateUDID];
        isSavedData = false;
    }
}


-(void)funSetInteractionFalseToAllTextfields
{
    
    self.txtBankName.userInteractionEnabled = false;
    self.txtCardHolderName.userInteractionEnabled = false;
    self.txtCardNumber.userInteractionEnabled = false;
    self.txtCardType.userInteractionEnabled = false;
    self.txtCardPIN.userInteractionEnabled = false;
    self.txtLocalPhone.userInteractionEnabled = false;
    self.txtTollFree.userInteractionEnabled = false;
    self.txtWebsite.userInteractionEnabled = false;
    self.noteButton.userInteractionEnabled = false;
    
    self.expiryDateButton.userInteractionEnabled = false;
    self.validFromButton.userInteractionEnabled = false;
    
    self.collectionViewPhotos.userInteractionEnabled = false;
    
}

-(void)EditCategory
{
    self.txtBankName.userInteractionEnabled = true;
    self.txtCardHolderName.userInteractionEnabled = true;
    self.txtCardNumber.userInteractionEnabled = true;
    self.txtCardType.userInteractionEnabled = true;
    self.txtCardPIN.userInteractionEnabled = true;
    self.txtLocalPhone.userInteractionEnabled = true;
    self.txtTollFree.userInteractionEnabled = true;
    self.txtWebsite.userInteractionEnabled = true;
    self.noteButton.userInteractionEnabled = true;
    
    self.expiryDateButton.userInteractionEnabled = true;
    self.validFromButton.userInteractionEnabled = true;
    
    self.collectionViewPhotos.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

-(void)AddSaveCreditCard
{
    //Validation
    //1. should have to enter bankName, accountNumber
    if (self.txtBankName.text.length == 0 && self.txtCardNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtCardNumber.layer.borderWidth = 1.0;
        self.txtCardNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtBankName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtCardNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtCardNumber.layer.borderWidth = 1.0;
        self.txtCardNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *objectKey = recordIDCategory;
    
    
    NSString *encCardNumber = [[AppData sharedAppData] encrypt:self.txtCardNumber.text withKey:[AppData sharedAppData].userAppPassword];
    NSString *encCardPIN = [[AppData sharedAppData] encrypt:self.txtCardPIN.text withKey:[AppData sharedAppData].userAppPassword];
    
    [object setValue:self.txtBankName.text forKey:@"title"];
    [object setValue:self.txtBankName.text forKey:@"bankName"];
    [object setValue:self.txtCardHolderName.text forKey:@"cardHolderName"];
    if (encCardNumber != nil)
    {
        [object setValue:encCardNumber forKey:@"cardNumber"];
    }
    else
    {
        [object setValue:@"" forKey:@"cardNumber"];
    }
    
    [object setValue:self.txtCardType.text forKey:@"cardType"];
    if (encCardPIN != nil)
    {
        [object setValue:encCardPIN forKey:@"cardPIN"];
    }
    else
    {
        [object setValue:@"" forKey:@"cardPIN"];
    }
    
    [object setValue:self.txtLocalPhone.text forKey:@"localPhone"];
    [object setValue:self.txtTollFree.text forKey:@"tollFreePhone"];
    [object setValue:self.txtWebsite.text forKey:@"website"];
    [object setValue:self.expiryDateButton.titleLabel.text forKey:@"expiryDate"];
    [object setValue:self.validFromButton.titleLabel.text forKey:@"validFrom"];
    
    [object setValue:[NSNumber numberWithInt:2] forKey:@"categoryType"];
    
    //    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    
    if (self.isFavourite == true)
    {
        [object setValue:[NSNumber numberWithBool:true] forKey:@"isFavourite"];
    }
    else
    {
        [object setValue:[NSNumber numberWithBool:false] forKey:@"isFavourite"];
    }
    
    //Save plist and in memory object
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc] init];
    [saveDict setObject:object forKey:objectKey];
    
    [[AppData sharedAppData] funSaveCategoryData:KCategoryCreditCard objectKey:objectKey dictionary:object];
    
    isSavedData = true;
    
    //pop to list view
    [self.navigationController popViewControllerAnimated:true];
}

-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.txtBankName.text forKey:@"title"];
    [object setValue:self.txtBankName.text forKey:@"bankName"];
    [object setValue:self.txtCardHolderName.text forKey:@"cardHolderName"];
    [object setValue:self.txtCardNumber.text forKey:@"cardNumber"];
    [object setValue:self.txtCardType.text forKey:@"cardType"];
    [object setValue:self.txtCardPIN.text forKey:@"cardPIN"];
    [object setValue:self.txtLocalPhone.text forKey:@"localPhone"];
    [object setValue:self.txtTollFree.text forKey:@"tollFreePhone"];
    [object setValue:self.txtWebsite.text forKey:@"website"];
    [object setValue:self.expiryDateButton.titleLabel.text forKey:@"expiryDate"];
    [object setValue:self.validFromButton.titleLabel.text forKey:@"validFrom"];
    //    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:2] forKey:@"categoryType"];
    
    return object;
    
}

-(void)funShowValidationAlert:(int)validationType
{
    switch (validationType) {
        case 1:
            [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}

- (IBAction)funShowHidePIN:(id)sender
{
    if (self.txtCardPIN.secureTextEntry == true)
    {
        self.txtCardPIN.secureTextEntry = false;
        [self.showHidePinBtn setTitle:@"Hide" forState:UIControlStateNormal];
    }
    else
    {
        self.txtCardPIN.secureTextEntry = true;
        [self.showHidePinBtn setTitle:@"Show" forState:UIControlStateNormal];
    }
}

-(void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark :- textfield delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark :- collectionview datasource/delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HorizontalScrollCell *hsc =[collectionView dequeueReusableCellWithReuseIdentifier:@"cvcHsc"
                                                                         forIndexPath:indexPath];
    hsc.title.text = @"Credit Card Photos";
    [hsc setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5f]];
    [hsc setUpCellWithArray:images];
    
    [hsc.scroll setFrame:CGRectMake(hsc.scroll.frame.origin.x, hsc.scroll.frame.origin.y, hsc.frame.size.width, 200)];
    
    hsc.cellDelegate = self;
    
    return hsc;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(self.view.frame.size.width - 10, 200);
    
    return retval;
}


@end
