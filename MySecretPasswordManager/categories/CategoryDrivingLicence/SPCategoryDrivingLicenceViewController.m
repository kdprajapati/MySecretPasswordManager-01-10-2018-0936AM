//
//  SPCategoryDrivingLicenceViewController.m
//  MySecretPasswordManager
//
//  Created by KrishnDip on 07/09/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SPCategoryDrivingLicenceViewController.h"
#import "SPPreviewViewPopupController.h"
#import "MainMenuCellTableViewCell.h"
#import "CoreDataStackManager.h"
#import "AppData.h"
#import "protocol.h"
#import "HorizontalScrollCell.h"
#import "PreviewNewViewController.h"
#import "ImageShowViewController.h"

#import "MySecretPasswordManager-Swift.h"

@interface SPCategoryDrivingLicenceViewController ()<HorizontalScrollCellDelegate>

@end

@implementation SPCategoryDrivingLicenceViewController
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
    self.title = @"Driving Licence";
    // Do any additional setup after loading the view from its nib.
    CGFloat contentRatio = ([UIScreen mainScreen].bounds.size.height*230)/320;
    self.scrolViewDrivingLicence.contentSize = CGSizeMake(self.scrolViewDrivingLicence.frame.size.width, self.onView.frame.size.height * 13.5 + 50);
    NSLog(@"scrolViewDrivingLicence - %@",NSStringFromCGSize(self.scrolViewDrivingLicence.contentSize));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveDrivingLicence)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    
    selectedIndexPath = [[NSIndexPath alloc] init];
    
    [self funAllocBottomBarButtons];
    
    [self funSetDataToViews];
    
    //    [self funCreateDataPicker];
    datePicker = [[UIDatePicker alloc] init];
    
    self.txtFullName.delegate = self;
    self.txtAddress.delegate = self;
    self.txtLicenceNumber.delegate = self;
    self.txtClassType.delegate = self;
    self.txtDocumentNumber.delegate = self;
    self.txtNote.delegate = self;
    
    scrollViewHeight = _scrolViewDrivingLicence.frame.size.height;
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
    
    if (self.ObjectDrivingLicence == nil)
    {
        [self funChangeRighBarButtonItemEditSave:false];
    }
    else
    {
        [self funChangeRighBarButtonItemEditSave:true];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.scrolViewDrivingLicence.contentSize = CGSizeMake(self.scrolViewDrivingLicence.frame.size.width, self.onView.frame.size.height * 13.5 + 50);
    [self.navigationController setToolbarHidden:false animated:true];
    
    [[AppData sharedAppData] showAddOnTopOfToolBar];
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
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveDrivingLicence)];
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
            NSString *filePath = [[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryDrivingLicence recordID:recordIDCategory];
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
    NSString *filePath = [appData funGetCategoryRecordIDDirectory:KCategoryDrivingLicence recordID:recordIDCategory];
    NSArray *arrayFileCount = [appData getListOfDirectoryOfCategoryType:KCategoryDrivingLicence recordID:recordIDCategory];
    i=arrayFileCount.count;
    
    //get full path
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%lu.png",(unsigned long)i]];
    
    //create directory
    [appData funCreateCategoryPhotosForRecordId:KCategoryDrivingLicence recordID:recordIDCategory];
    
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
    NSArray *arrayListFiles = [[AppData sharedAppData] getListOfDirectoryOfCategoryType:KCategoryDrivingLicence recordID:recordIDCategory];
    
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
        NSString *filePath = [[[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryDrivingLicence recordID:recordIDCategory] stringByAppendingPathComponent:fileName];
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
    NSString *recordID = [self.ObjectDrivingLicence valueForKey:@"recordID"];
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
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategoryDrivingLicence recordIDToDelete:recordID];
                                  
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
    PreviewNewViewController *categoryVC = [[PreviewNewViewController alloc]initWithNibName:@"PreviewNewViewController" bundle:[NSBundle mainBundle]];
    
    categoryVC.previewObject = [self funReturnCurrentObjectForPreview];
    categoryVC.categoryType = KCategoryDrivingLicence;
    
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
    
    _scrolViewDrivingLicence.frame = CGRectMake(_scrolViewDrivingLicence.frame.origin.x, _scrolViewDrivingLicence.frame.origin.y, _scrolViewDrivingLicence.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewDrivingLicence.frame = CGRectMake(_scrolViewDrivingLicence.frame.origin.x, _scrolViewDrivingLicence.frame.origin.y, _scrolViewDrivingLicence.frame.size.width, _scrolViewDrivingLicence.frame.size.height + keyboardFrame.size.height);
}

- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}

-(void)funDoFavourite
{
    if (self.txtFullName.text.length == 0 && self.txtLicenceNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtFullName.layer.borderWidth = 1.0;
        self.txtFullName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtLicenceNumber.layer.borderWidth = 1.0;
        self.txtLicenceNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtFullName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtFullName.layer.borderWidth = 1.0;
        self.txtFullName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtLicenceNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtLicenceNumber.layer.borderWidth = 1.0;
        self.txtLicenceNumber.layer.borderColor = [UIColor redColor].CGColor;
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
            senderFrame = _issueDateButton.frame;
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

- (IBAction)funIssueDateClicked:(id)sender
{
    [self funCreateDatePicker];
    dateViewTag = 8;
}

- (IBAction)funDOBDateClicked:(id)sender {
    [self funCreateDatePicker];
    dateViewTag = 9;
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
            [self.ObjectDrivingLicence setValue:pickedDate forKey:@"expiryDate"];
            break;
        case 8:
            [self.issueDateButton setTitle:stringDate forState:UIControlStateNormal];
            [self.ObjectDrivingLicence setValue:pickedDate forKey:@"issueDate"];
            break;
        case 9:
            [self.DateOfBirthButton setTitle:stringDate forState:UIControlStateNormal];
            [self.ObjectDrivingLicence setValue:pickedDate forKey:@"DOB"];
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
    if (self.ObjectDrivingLicence != nil)
    {
        self.txtFullName.text = [self.ObjectDrivingLicence valueForKey:@"fullName"];
        self.txtAddress.text = [self.ObjectDrivingLicence valueForKey:@"address"];
        self.txtLicenceNumber.text = [self.ObjectDrivingLicence valueForKey:@"licenceNumber"];
        self.txtClassType.text = [self.ObjectDrivingLicence valueForKey:@"classType"];
        self.txtDocumentNumber.text = [self.ObjectDrivingLicence valueForKey:@"documentNumber"];
        //        self.txtNote.text = [self.ObjectDrivingLicence valueForKey:@"note"];
        if ([self.ObjectDrivingLicence valueForKey:@"note"] != nil)
        {
            [self.noteButton setTitle:[self.ObjectDrivingLicence valueForKey:@"note"] forState:UIControlStateNormal];
        }
        else{
            [self.noteButton setTitle:[self.ObjectDrivingLicence valueForKey:@"Tap to create note"] forState:UIControlStateNormal];
        }
        
        id dob = [self.ObjectDrivingLicence valueForKey:@"DOB"];
        if (dob != nil)
        {
            [self.DateOfBirthButton setTitle:[NSString stringWithFormat:@"%@",dob] forState:UIControlStateNormal];
        }
        else
        {
            [self.DateOfBirthButton setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
        
        id expiryDate = [self.ObjectDrivingLicence valueForKey:@"expiryDate"];
        if (expiryDate != nil)
        {
            [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",expiryDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
        
        id issueDate = [self.ObjectDrivingLicence valueForKey:@"issueDate"];
        if (issueDate != nil)
        {
            [self.issueDateButton setTitle:[NSString stringWithFormat:@"%@",issueDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.issueDateButton setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
        
        self.isFavourite = [[self.ObjectDrivingLicence valueForKey:@"isFavourite"] boolValue];
        
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
        
        [self.DateOfBirthButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
        [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
        [self.issueDateButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
    }
    
    if (self.ObjectDrivingLicence != nil)
    {
        recordIDCategory = [self.ObjectDrivingLicence valueForKey:@"recordID"];
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
    self.txtFullName.userInteractionEnabled = false;
    self.txtAddress.userInteractionEnabled = false;
    self.txtLicenceNumber.userInteractionEnabled = false;
    self.txtClassType.userInteractionEnabled = false;
    self.txtDocumentNumber.userInteractionEnabled = false;
    self.DateOfBirthButton.userInteractionEnabled = false;
    self.issueDateButton.userInteractionEnabled = false;
    self.expiryDateButton.userInteractionEnabled = false;
    self.noteButton.userInteractionEnabled = false;
    
    self.collectionViewPhotos.userInteractionEnabled = false;
}

-(void)EditCategory
{
    self.txtFullName.userInteractionEnabled = true;
    self.txtAddress.userInteractionEnabled = true;
    self.txtLicenceNumber.userInteractionEnabled = true;
    self.txtClassType.userInteractionEnabled = true;
    self.txtDocumentNumber.userInteractionEnabled = true;
    self.DateOfBirthButton.userInteractionEnabled = true;
    self.issueDateButton.userInteractionEnabled = true;
    self.expiryDateButton.userInteractionEnabled = true;
    self.noteButton.userInteractionEnabled = true;
    
    self.collectionViewPhotos.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

-(void)AddSaveDrivingLicence
{
    
    //Validation
    //1. should have to enter bankName, accountNumber
    if (self.txtFullName.text.length == 0 && self.txtLicenceNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtFullName.layer.borderWidth = 1.0;
        self.txtFullName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtLicenceNumber.layer.borderWidth = 1.0;
        self.txtLicenceNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtFullName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtFullName.layer.borderWidth = 1.0;
        self.txtFullName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtLicenceNumber.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtLicenceNumber.layer.borderWidth = 1.0;
        self.txtLicenceNumber.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *objectKey = recordIDCategory;
    
    [object setValue:self.txtFullName.text forKey:@"title"];
    [object setValue:self.txtFullName.text forKey:@"fullName"];
    [object setValue:self.txtAddress.text forKey:@"address"];
    [object setValue:self.txtLicenceNumber.text forKey:@"licenceNumber"];
    [object setValue:self.txtClassType.text forKey:@"classType"];
    [object setValue:self.txtDocumentNumber.text forKey:@"documentNumber"];
    [object setValue:self.DateOfBirthButton.titleLabel.text forKey:@"DOB"];
    [object setValue:self.issueDateButton.titleLabel.text forKey:@"issueDate"];
    [object setValue:self.expiryDateButton.titleLabel.text forKey:@"expiryDate"];
    [object setValue:[NSNumber numberWithInt:6] forKey:@"categoryType"];
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
    
    [[AppData sharedAppData] funSaveCategoryData:KCategoryDrivingLicence objectKey:objectKey dictionary:object];
    
    isSavedData = true;
    
    //pop to list view
    [self.navigationController popViewControllerAnimated:true];
}

-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.txtFullName.text forKey:@"title"];
    [object setValue:self.txtFullName.text forKey:@"fullName"];
    [object setValue:self.txtAddress.text forKey:@"address"];
    [object setValue:self.txtLicenceNumber.text forKey:@"licenceNumber"];
    [object setValue:self.txtClassType.text forKey:@"classType"];
    [object setValue:self.txtDocumentNumber.text forKey:@"documentNumber"];
    [object setValue:self.DateOfBirthButton.titleLabel.text forKey:@"DOB"];
    [object setValue:self.issueDateButton.titleLabel.text forKey:@"issueDate"];
    [object setValue:self.expiryDateButton.titleLabel.text forKey:@"expiryDate"];
    //    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:6] forKey:@"categoryType"];
    
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
    hsc.title.text = @"Driving Licence Photos";
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

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
