//
//  SPIdentityViewController.m
//  MySecretPasswordManager
//
//  Created by Nilesh on 4/5/18.
//  Copyright © 2018 nil. All rights reserved.
//
#import "SPPreviewViewPopupController.h"
#import "SPIdentityViewController.h"
#import "CoreDataStackManager.h"
#import "AppData.h"
#import "PreviewNewViewController.h"
#import "ImageShowViewController.h"
#import "HorizontalScrollCell.h"

@interface SPIdentityViewController ()<HorizontalScrollCellDelegate>
{
    UIDatePicker *datePicker;
    CGFloat scrollViewHeight;
    NSString *recordIDCategory;
    BOOL isSavedData;
}
@end

@implementation SPIdentityViewController
{
    NSMutableArray *images;
    NSMutableArray *imagePathsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Identity";
    
//    _scrollViewIdentity.frame = CGRectMake(_scrollViewIdentity.frame.origin.x, _scrollViewIdentity.frame.origin.y, _scrollViewIdentity.frame.size.width, [UIScreen mainScreen].bounds.size.height - 55);
    
    self.scrollViewIdentity.contentSize = CGSizeMake(self.scrollViewIdentity.frame.size.width, self.noteView.frame.size.height * 15 + 50);
  
    datePicker = [[UIDatePicker alloc] init];

    self.txtIdentityTitle.delegate = self;
    self.txtFirstName.delegate = self;
    self.txtLastName.delegate = self;
    self.txtEmail.delegate = self;
    self.txtOccupation.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtWebsite.delegate = self;
    self.txtAddress.delegate = self;
    self.txtCountry.delegate = self;
    self.txtNote.delegate = self;
    
    scrollViewHeight = _scrollViewIdentity.frame.size.height;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self funSetDataToViews];
    
    [self prepareImages];
    
    [self setUpCollection];
    
    if (self.identityObject == nil)
    {
        [self funChangeRighBarButtonItemEditSave:false];
    }
    else
    {
        [self funChangeRighBarButtonItemEditSave:true];
    }
    
    [self funAllocBottomBarButtons];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.scrollViewIdentity.contentSize = CGSizeMake(self.scrollViewIdentity.frame.size.width, self.noteView.frame.size.height * 15 + 50);
    
    [self.navigationController setToolbarHidden:false animated:true];
    
    [[AppData sharedAppData] showAddOnTopOfToolBar];
    
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
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveIdentity)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isBeingDismissed] || [self isMovingFromParentViewController])
    {
        if (isSavedData == false)
        {
            NSString *filePath = [[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryIdentity recordID:recordIDCategory];
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            NSLog(@"error deleting photo - %@",error);
        }
    }
}

- (IBAction)funAddPhotos:(id)sender {
    [self funShowCameraOptions];
}

-(void)cellSelected:(UIImage *)image
{
    ImageShowViewController *imageShowVC = [[ImageShowViewController alloc]initWithNibName:@"ImageShowViewController" bundle:[NSBundle mainBundle]];
    imageShowVC.imageDetail = image;
    [self.navigationController pushViewController:imageShowVC animated:true];
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
    NSString *filePath = [appData funGetCategoryRecordIDDirectory:KCategoryIdentity recordID:recordIDCategory];
    NSArray *arrayFileCount = [appData getListOfDirectoryOfCategoryType:KCategoryIdentity recordID:recordIDCategory];
    i=arrayFileCount.count;
    
    //get full path
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%lu.png",(unsigned long)i]];
    
    //create directory
    [appData funCreateCategoryPhotosForRecordId:KCategoryIdentity recordID:recordIDCategory];
    
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

-(void)prepareImages
{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSArray *arrayListFiles = [[AppData sharedAppData] getListOfDirectoryOfCategoryType:KCategoryIdentity recordID:recordIDCategory];
    
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
        NSString *filePath = [[[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryIdentity recordID:recordIDCategory] stringByAppendingPathComponent:fileName];
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


- (IBAction)funSetBirthDate:(id)sender
{
    [self funCreateDatePicker];
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
        CGRect senderFrame;//= sender.frame;//CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 320,
        
        senderFrame = _birthDate.frame;
        
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:dateAlert];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        
        [self presentViewController:dateAlert animated:true completion:nil];
    }
}

-(void)funDatePicked
{
    NSDate *pickedDate = [datePicker date];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateStyle = kCFDateFormatterShortStyle;
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *stringDate = [formatter stringFromDate:pickedDate];//[NSString stringWithFormat:@"%@",pickedDate];

    [self.birthDate setTitle:stringDate forState:UIControlStateNormal];
    [self.identityObject setValue:pickedDate forKey:@"birthDate"];
    
}

#pragma mark:- keyboard notifications
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrollViewIdentity.frame = CGRectMake(_scrollViewIdentity.frame.origin.x, _scrollViewIdentity.frame.origin.y, _scrollViewIdentity.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrollViewIdentity.frame = CGRectMake(_scrollViewIdentity.frame.origin.x, _scrollViewIdentity.frame.origin.y, _scrollViewIdentity.frame.size.width, _scrollViewIdentity.frame.size.height + keyboardFrame.size.height - 50);
    
}
- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}

-(void)funDoFavourite
{
    if (self.txtIdentityTitle.text.length == 0 && self.txtFirstName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtIdentityTitle.layer.borderWidth = 1.0;
        self.txtIdentityTitle.layer.borderColor = [UIColor redColor].CGColor;
        self.txtFirstName.layer.borderWidth = 1.0;
        self.txtFirstName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtIdentityTitle.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtIdentityTitle.layer.borderWidth = 1.0;
        self.txtIdentityTitle.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtFirstName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtFirstName.layer.borderWidth = 1.0;
        self.txtFirstName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    else
    {
        if (self.isFavourite == true)
        {
            self.isFavourite = false;
            [self.favouriteBtn setSelected:false];
//            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            self.isFavourite = true;
            [self.favouriteBtn setSelected:true];
//            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateSelected];
        }
        
    }
}

- (IBAction)funDeleteObject:(id)sender
{
    NSString *recordID = [self.identityObject valueForKey:@"recordID"];
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
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategoryIdentity recordIDToDelete:recordID];
                                  
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
    categoryVC.categoryType = KCategoryIdentity;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}

-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.txtIdentityTitle.text forKey:@"title"];
    [object setValue:self.txtFirstName.text forKey:@"firstName"];
    [object setValue:self.txtLastName.text forKey:@"lastName"];
    [object setValue:self.txtEmail.text forKey:@"email"];
    [object setValue:self.txtOccupation.text forKey:@"occupation"];
    [object setValue:self.txtPhoneNumber.text forKey:@"phoneNumber"];
    [object setValue:self.txtWebsite.text forKey:@"webSite"];
    [object setValue:self.txtAddress.text forKey:@"address"];
    [object setValue:self.txtCountry.text forKey:@"country"];
//    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:4] forKey:@"categoryType"];
    
    return object;
    
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
    if (self.identityObject != nil)
    {
        self.txtIdentityTitle.text = [self.identityObject valueForKey:@"title"];
        self.txtFirstName.text = [self.identityObject valueForKey:@"firstName"];
        self.txtLastName.text = [self.identityObject valueForKey:@"lastName"];
        self.txtEmail.text = [self.identityObject valueForKey:@"email"];
        self.txtOccupation.text = [self.identityObject valueForKey:@"occupation"];
        self.txtPhoneNumber.text = [self.identityObject valueForKey:@"phoneNumber"];
        self.txtWebsite.text = [self.identityObject valueForKey:@"webSite"];
        self.txtAddress.text = [self.identityObject valueForKey:@"address"];
        self.txtCountry.text = [self.identityObject valueForKey:@"country"];
//        self.txtNote.text = [self.identityObject valueForKey:@"note"];
        if ([self.identityObject valueForKey:@"note"] != nil)
        {
            [self.noteButton setTitle:[self.identityObject valueForKey:@"note"] forState:UIControlStateNormal];
        }
        else{
            [self.noteButton setTitle:[self.identityObject valueForKey:@"Tap to create note"] forState:UIControlStateNormal];
        }

        self.isFavourite = [[self.identityObject valueForKey:@"isFavourite"] boolValue];
        if (self.isFavourite == true)
        {
            self.isFavourite = true;
            [self.favouriteBtn setSelected:true];
//            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateSelected];
            
        }
        else
        {
            self.isFavourite = false;
            [self.favouriteBtn setSelected:false];
//            [self.favouriteBtn setBackgroundImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
        }
        
        id expiryDate = [self.identityObject valueForKey:@"birthDate"];
        if (expiryDate != nil)
        {
            [self.birthDate setTitle:[NSString stringWithFormat:@"%@",expiryDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.birthDate setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
    }
    else
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [NSDate date];
        
        [self.birthDate setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
    }
    
    if (self.identityObject != nil)
    {
        recordIDCategory = [self.identityObject valueForKey:@"recordID"];
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
    
    self.txtIdentityTitle.userInteractionEnabled = false;
    self.txtFirstName.userInteractionEnabled = false;
    self.txtLastName.userInteractionEnabled = false;
    self.txtEmail.userInteractionEnabled = false;
    self.txtOccupation.userInteractionEnabled = false;
    self.txtPhoneNumber.userInteractionEnabled = false;
    self.txtWebsite.userInteractionEnabled = false;
    self.txtAddress.userInteractionEnabled = false;
    self.txtCountry.userInteractionEnabled = false;
    self.noteButton.userInteractionEnabled = false;
    
    self.birthDate.userInteractionEnabled = false;
    
    self.collectionViewPhotos.userInteractionEnabled = false;
}

-(void)EditCategory
{
    self.txtIdentityTitle.userInteractionEnabled = true;
    self.txtFirstName.userInteractionEnabled = true;
    self.txtLastName.userInteractionEnabled = true;
    self.txtEmail.userInteractionEnabled = true;
    self.txtOccupation.userInteractionEnabled = true;
    self.txtPhoneNumber.userInteractionEnabled = true;
    self.txtWebsite.userInteractionEnabled = true;
    self.txtAddress.userInteractionEnabled = true;
    self.txtCountry.userInteractionEnabled = true;
    self.noteButton.userInteractionEnabled = true;
    
    self.birthDate.userInteractionEnabled = true;

    self.collectionViewPhotos.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

-(void)AddSaveIdentity
{
    
    //Validation
    if (self.txtIdentityTitle.text.length == 0 && self.txtFirstName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtIdentityTitle.layer.borderWidth = 1.0;
        self.txtIdentityTitle.layer.borderColor = [UIColor redColor].CGColor;
        self.txtFirstName.layer.borderWidth = 1.0;
        self.txtFirstName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtIdentityTitle.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtIdentityTitle.layer.borderWidth = 1.0;
        self.txtIdentityTitle.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtFirstName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtFirstName.layer.borderWidth = 1.0;
        self.txtFirstName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *objectKey;
    if (self.identityObject != nil)
    {
        objectKey = [self.identityObject valueForKey:@"recordID"];
    }
    else
    {
        objectKey = [[CoreDataStackManager sharedManager] funGenerateUDID];
    }
    
    
    [object setValue:self.txtIdentityTitle.text forKey:@"title"];
    
    [object setValue:self.txtFirstName.text forKey:@"firstName"];
    [object setValue:self.txtLastName.text forKey:@"lastName"];
    
    [object setValue:self.txtEmail.text forKey:@"email"];
    [object setValue:self.txtOccupation.text forKey:@"occupation"];
    [object setValue:self.txtPhoneNumber.text forKey:@"phoneNumber"];
    [object setValue:self.txtWebsite.text forKey:@"webSite"];
    [object setValue:self.txtAddress.text forKey:@"address"];
    [object setValue:self.txtCountry.text forKey:@"country"];
//    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    
    [object setValue:[NSNumber numberWithInt:4] forKey:@"categoryType"];
    if (self.isFavourite == true)
    {
        [object setValue:[NSNumber numberWithBool:true] forKey:@"isFavourite"];
    }
    else
    {
        [object setValue:[NSNumber numberWithBool:false] forKey:@"isFavourite"];
    }
    [object setValue:self.birthDate.titleLabel.text forKey:@"birthDate"];

    
    //Save plist and in memory object
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc] init];
    [saveDict setObject:object forKey:objectKey];
    
    [[AppData sharedAppData] funSaveCategoryData:KCategoryIdentity objectKey:objectKey dictionary:object];
    
    isSavedData = true;
    
    //pop to list view
    [self.navigationController popViewControllerAnimated:true];
}

-(void)funShowValidationAlert:(int)validationType
{
    switch (validationType) {
        case 1:
            [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
            break;
        default:
            break;
    }
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
    hsc.title.text = @"Identity Photos";
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

-(void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
