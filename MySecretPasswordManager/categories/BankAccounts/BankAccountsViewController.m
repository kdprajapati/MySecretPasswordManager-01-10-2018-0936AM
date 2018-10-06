//
//  BankAccountsViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 24/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "SPPreviewViewPopupController.h"
#import "BankAccountsViewController.h"
#import "MainMenuCellTableViewCell.h"
#import "CoreDataStackManager.h"
#import "ImageShowViewController.h"
#import "AppData.h"

#import "HorizontalScrollCell.h"

#import "PreviewNewViewController.h"

@interface BankAccountsViewController ()<HorizontalScrollCellDelegate>
{
    UIDatePicker *datePicker;
    CGFloat scrollViewHeight;
    NSString *recordIDCategory;
    BOOL isSavedData;
}

@end

@implementation BankAccountsViewController
{
    NSMutableArray *images;
    NSMutableArray *imagePathsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bank Account";
    
    self.scrolViewBankAC.contentSize = CGSizeMake(self.scrolViewBankAC.frame.size.width, self.onView.frame.size.height * 14.5 + 50);
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Bank Account";
    
    
//    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveBankAccount)];
   
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    
    [self funSetDataToViews];
 
    self.txtBankName.delegate = self;
    self.txtAccountNumber.delegate = self;
    self.txtAccountHolderName.delegate = self;
    self.txtAccountType.delegate = self;
    self.txtPIN.delegate = self;
    self.txtBranchCode.delegate = self;
    self.txtBranchPhone.delegate = self;
    self.txtBranchAddress.delegate = self;
    self.txtNote.delegate = self;
    
    
    scrollViewHeight = _scrolViewBankAC.frame.size.height;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self prepareImages];
    
    [self setUpCollection];
    
    [self funChangeRighBarButtonItemEditSave:true];
    
    [self funAllocBottomBarButtons];
}

/**
 add bottom bar buttons - favourite and settings
 */
-(void)funAllocBottomBarButtons
{
    
    UIBarButtonItem *flexibalSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *favBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [favBtn setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
    [favBtn addTarget:self action:@selector(funDoFavourite) forControlEvents:UIControlEventTouchUpInside];
    favBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIBarButtonItem *favouriteBtn = [[UIBarButtonItem alloc] initWithCustomView:favBtn];
    
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
    
    self.toolbarItems = [NSArray arrayWithObjects: favouriteBtn,flexibalSpace, shareBtnBar,flexibalSpace, deleteBtnBar, nil];

    
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
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveBankAccount)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.scrolViewBankAC.contentSize = CGSizeMake(self.scrolViewBankAC.frame.size.width, self.onView.frame.size.height * 14.5 + 50);
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
    NSString *filePath = [appData funGetCategoryRecordIDDirectory:KCategoryBankAccount recordID:recordIDCategory];
    NSArray *arrayFileCount = [appData getListOfDirectoryOfCategoryType:KCategoryBankAccount recordID:recordIDCategory];
    i=arrayFileCount.count;
    
    //get full path
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%lu.png",(unsigned long)i]];
    
    //create directory
    [appData funCreateCategoryPhotosForRecordId:KCategoryBankAccount recordID:recordIDCategory];
    
    [pngData writeToFile:filePath atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self funUpdateCollectionPhotos];
    }];
    
}

-(void)funUpdateCollectionPhotos
{
    [self prepareImages];
    [self.collectionViewPhotos reloadData];
}

-(void)viewDidLayoutSubviews
{
//    [self.collectionViewPhotos setFrame:CGRectMake(0, 200, self.view.frame.size.width, 150)];
}

-(void)prepareImages
{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSArray *arrayListFiles = [[AppData sharedAppData] getListOfDirectoryOfCategoryType:KCategoryBankAccount recordID:recordIDCategory];
    
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
        NSString *filePath = [[[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryBankAccount recordID:recordIDCategory] stringByAppendingPathComponent:fileName];
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

//Horizontalscroll cell delegate method
-(void)funRemoveImage:(int)tag
{
    NSString *imageToDeletePath = [imagePathsArray objectAtIndex:tag];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imageToDeletePath error:&error];
    NSLog(@"error deleting photo - %@",error);
    
    [self performSelector:@selector(funUpdateCollectionPhotos) withObject:nil afterDelay:0.5];
}

#pragma mark:- keyboard notifications
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewBankAC.frame = CGRectMake(_scrolViewBankAC.frame.origin.x, _scrolViewBankAC.frame.origin.y, _scrolViewBankAC.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewBankAC.frame = CGRectMake(_scrolViewBankAC.frame.origin.x, _scrolViewBankAC.frame.origin.y, _scrolViewBankAC.frame.size.width, _scrolViewBankAC.frame.size.height + keyboardFrame.size.height);
}

- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}


-(void)funDoFavourite
{
    if (self.txtBankName.text.length == 0 && self.txtAccountNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtAccountNumber.layer.borderWidth = 1.0;
        self.txtAccountNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtBankName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtAccountNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtAccountNumber.layer.borderWidth = 1.0;
        self.txtAccountNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    else
    {
        if (self.isFavourite == true)
        {
            self.isFavourite = false;
            [self.favouriteBtn setSelected:false];
            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            self.isFavourite = true;
            [self.favouriteBtn setSelected:true];
            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateSelected];
        }
        
    }
}

- (IBAction)funPreviewShare:(id)sender
{
//    SPPreviewViewPopupController *categoryVC = [[SPPreviewViewPopupController alloc]initWithNibName:@"SPPreviewViewPopupController" bundle:[NSBundle mainBundle]];
    
    PreviewNewViewController *categoryVC = [[PreviewNewViewController alloc]initWithNibName:@"PreviewNewViewController" bundle:[NSBundle mainBundle]];
    
    categoryVC.previewObject = [self funReturnCurrentObjectForPreview];
    categoryVC.categoryType = KCategoryBankAccount;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}


- (IBAction)funDeleteObject:(id)sender
{
    NSString *recordID = [self.bankObject valueForKey:@"recordID"];
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
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategoryBankAccount recordIDToDelete:recordID];
                                  
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
    if (self.bankObject != nil)
    {
        self.txtPIN.secureTextEntry = true;
        
        NSString *decACPIN = [[AppData sharedAppData] decrypt:[self.bankObject valueForKey:@"accountPIN"] withKey:[AppData sharedAppData].userAppPassword];
        
        self.txtBankName.text = [self.bankObject valueForKey:@"bankName"];
        self.txtAccountNumber.text = [self.bankObject valueForKey:@"accountNumber"];
        self.txtAccountHolderName.text = [self.bankObject valueForKey:@"accountHolderName"];
        self.txtAccountType.text = [self.bankObject valueForKey:@"accountType"];
        self.txtUserId.text = [self.bankObject valueForKey:@"userID"];
        if (decACPIN != nil)
        {
            self.txtPIN.text = decACPIN;
        }
        self.txtBranchCode.text = [self.bankObject valueForKey:@"branchCode"];
        self.txtBranchPhone.text = [self.bankObject valueForKey:@"branchPhone"];
        self.txtBranchAddress.text = [self.bankObject valueForKey:@"branchAddress"];
//        self.txtNote.text = [self.bankObject valueForKey:@"note"];
        if ([self.bankObject valueForKey:@"note"] != nil)
        {
            [self.noteButton setTitle:[self.bankObject valueForKey:@"note"] forState:UIControlStateNormal];
        }
        else{
            [self.noteButton setTitle:[self.bankObject valueForKey:@"Tap to create note"] forState:UIControlStateNormal];
        }
        
        self.isFavourite = [[self.bankObject valueForKey:@"isFavourite"] boolValue];
        
        if (self.isFavourite == true)
        {
            self.isFavourite = true;
            [self.favouriteBtn setSelected:true];
            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateSelected];
            
        }
        else
        {
            self.isFavourite = false;
            [self.favouriteBtn setSelected:false];
            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
        }
    }
    
    if (self.bankObject != nil)
    {
        recordIDCategory = [self.bankObject valueForKey:@"recordID"];
        isSavedData = true;
    }
    else
    {
        recordIDCategory = [[CoreDataStackManager sharedManager] funGenerateUDID];
        isSavedData = false;
    }
    
}

-(void)funSetInteractionFalseToAllTextfields
{
    self.txtBankName.userInteractionEnabled = false;
    self.txtBankName.userInteractionEnabled = false;
    self.txtAccountNumber.userInteractionEnabled = false;
    self.txtAccountHolderName.userInteractionEnabled = false;
    self.txtAccountType.userInteractionEnabled = false;
    self.txtUserId.userInteractionEnabled = false;
    self.txtPIN.userInteractionEnabled = false;
    self.txtBranchCode.userInteractionEnabled = false;
    self.txtBranchPhone.userInteractionEnabled = false;
    self.txtBranchAddress.userInteractionEnabled = false;
    self.noteButton.userInteractionEnabled = false;
    
    self.collectionViewPhotos.userInteractionEnabled = false;
}

-(void)EditCategory
{
    self.txtBankName.userInteractionEnabled = true;
    self.txtBankName.userInteractionEnabled = true;
    self.txtAccountNumber.userInteractionEnabled = true;
    self.txtAccountHolderName.userInteractionEnabled = true;
    self.txtAccountType.userInteractionEnabled = true;
    self.txtUserId.userInteractionEnabled = true;
    self.txtPIN.userInteractionEnabled = true;
    self.txtBranchCode.userInteractionEnabled = true;
    self.txtBranchPhone.userInteractionEnabled = true;
    self.txtBranchAddress.userInteractionEnabled = true;
    self.noteButton.userInteractionEnabled = true;
    
    self.collectionViewPhotos.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

-(void)AddSaveBankAccount
{
    
    //Validation
    //1. should have to enter bankName, accountNumber
    if (self.txtBankName.text.length == 0 && self.txtAccountNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtAccountNumber.layer.borderWidth = 1.0;
        self.txtAccountNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtBankName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtBankName.layer.borderWidth = 1.0;
        self.txtBankName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtAccountNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtAccountNumber.layer.borderWidth = 1.0;
        self.txtAccountNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    //get current object
    NSMutableDictionary *object = [self funReturnCurrentObjectToSave];
    
    NSString *objectKey = recordIDCategory;
    
    //Save plist and in memory object
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc] init];
    [saveDict setObject:object forKey:objectKey];
    
    [[AppData sharedAppData] funSaveCategoryData:KCategoryBankAccount objectKey:objectKey dictionary:object];
    
    [[AppData sharedAppData] funCreateCategoryPhotosForRecordId:KCategoryBankAccount recordID:objectKey];
    
    isSavedData = true;
    
    //pop to list view
    [self.navigationController popViewControllerAnimated:true];
}

-(NSMutableDictionary *)funReturnCurrentObjectToSave
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *encACNumber = [[AppData sharedAppData] encrypt:self.txtAccountNumber.text withKey:[AppData sharedAppData].userAppPassword];
    NSString *encACPIN = [[AppData sharedAppData] encrypt:self.txtPIN.text withKey:[AppData sharedAppData].userAppPassword];
    
    
    
    [object setValue:self.txtBankName.text forKey:@"title"];
    [object setValue:self.txtBankName.text forKey:@"bankName"];
    if (encACNumber != nil)
    {
        [object setValue:encACNumber forKey:@"accountNumber"];
    }
    else
    {
        [object setValue:@"" forKey:@"accountNumber"];
    }
    [object setValue:self.txtAccountHolderName.text forKey:@"accountHolderName"];
    [object setValue:self.txtAccountType.text forKey:@"accountType"];
    
    [object setValue:self.txtUserId.text forKey:@"userID"];
    if (encACPIN != nil)
    {
        [object setValue:encACPIN forKey:@"accountPIN"];
    }
    else
    {
        [object setValue:@"" forKey:@"accountPIN"];
    }
    
    [object setValue:self.txtBranchCode.text forKey:@"branchCode"];
    [object setValue:self.txtBranchPhone.text forKey:@"branchPhone"];
    [object setValue:self.txtBranchAddress.text forKey:@"branchAddress"];
//    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    
    [object setValue:[NSNumber numberWithInt:1] forKey:@"categoryType"];
    
    if (self.isFavourite == true)
    {
        [object setValue:[NSNumber numberWithBool:true] forKey:@"isFavourite"];
    }
    else
    {
        [object setValue:[NSNumber numberWithBool:false] forKey:@"isFavourite"];
    }
    
    return object;
    
}

-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.txtBankName.text forKey:@"title"];
    [object setValue:self.txtBankName.text forKey:@"bankName"];
    [object setValue:self.txtAccountNumber.text forKey:@"accountNumber"];
    [object setValue:self.txtAccountHolderName.text forKey:@"accountHolderName"];
    [object setValue:self.txtAccountType.text forKey:@"accountType"];
    [object setValue:self.txtUserId.text forKey:@"userID"];
    [object setValue:self.txtPIN.text forKey:@"accountPIN"];
    [object setValue:self.txtBranchCode.text forKey:@"branchCode"];
    [object setValue:self.txtBranchPhone.text forKey:@"branchPhone"];
    [object setValue:self.txtBranchAddress.text forKey:@"branchAddress"];
//    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:1] forKey:@"categoryType"];
    
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
    if (self.txtPIN.secureTextEntry == true)
    {
        self.txtPIN.secureTextEntry = false;
        [self.showHidePinBtn setTitle:@"Hide" forState:UIControlStateNormal];
//        [self.showHidePinBtn setImage:[UIImage imageNamed:@"hide_pin.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.txtPIN.secureTextEntry = true;
        [self.showHidePinBtn setTitle:@"Show" forState:UIControlStateNormal];
//        [self.showHidePinBtn setImage:[UIImage imageNamed:@"show_pin.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)copyBankACNumber:(id)sender {
    NSString *copyStringverse = _txtAccountNumber.text;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
    
    [[AppData sharedAppData] showAlertWithMessage:@"\"Account Number\" Copied successfuly." andTitle:@"Success"];
}


#pragma mark :- textfield delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
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
    hsc.title.text = @"Bank Account Photos";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
