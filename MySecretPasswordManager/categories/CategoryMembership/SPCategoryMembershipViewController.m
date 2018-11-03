//
//  SPCategoryMembershipViewController.m
//  MySecretPasswordManager
//
//  Created by KrishnDip on 07/09/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SPCategoryMembershipViewController.h"
#import "SPPreviewViewPopupController.h"
#import "MainMenuCellTableViewCell.h"
#import "CoreDataStackManager.h"
#import "AppData.h"
#import "protocol.h"
#import "HorizontalScrollCell.h"
#import "PreviewNewViewController.h"
#import "ImageShowViewController.h"

#import "MySecretPasswordManager-Swift.h"

@interface SPCategoryMembershipViewController ()<HorizontalScrollCellDelegate>

@end

@implementation SPCategoryMembershipViewController
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
    UIImageView *noImageView;
    UIImage *favouriteTintImage;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Membership";
    
    // Do any additional setup after loading the view from its nib.
    CGFloat contentRatio = ([UIScreen mainScreen].bounds.size.height*230)/320;
    self.scrolViewMembership.contentSize = CGSizeMake(self.scrolViewMembership.frame.size.width, self.onView.frame.size.height * 13.5 + 50);
    NSLog(@"scrolViewMembership - %@",NSStringFromCGSize(self.scrolViewMembership.contentSize));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveMembership)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    
    selectedIndexPath = [[NSIndexPath alloc] init];
    
    [self funAllocBottomBarButtons];
    
    [self funSetDataToViews];
    
    //    [self funCreateDataPicker];
    datePicker = [[UIDatePicker alloc] init];
    
    self.txtWebsite.delegate = self;
    self.txtGroupName.delegate = self;
    self.txtTelephone.delegate = self;
    self.txtMemberName.delegate = self;
    self.txtMemberID.delegate = self;
    self.txtMemberPassword.delegate = self;
    self.txtNote.delegate = self;
    
    scrollViewHeight = _scrolViewMembership.frame.size.height;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /*noImageYetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.collectionViewPhotos.frame.size.width, 44)];
    noImageYetLabel.text = @"No Photos Yet!";
    noImageYetLabel.textAlignment = NSTextAlignmentCenter;
    noImageYetLabel.center = self.collectionViewPhotos.center;
    [self.collectionViewPhotos addSubview:noImageYetLabel];
    noImageYetLabel.hidden = true;*/
    
    noImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImage *imageNoImg = [[UIImage imageNamed:@"noImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    noImageView.image = imageNoImg;
    [noImageView setTintColor:[[AppData sharedAppData] funGetThemeColor]];
    [self.collectionViewPhotos addSubview:noImageView];
    noImageView.hidden = true;
    
    [self prepareImages];
    
    [self setUpCollection];
    
    if (self.ObjectMembership == nil)
    {
        [self funChangeRighBarButtonItemEditSave:false];
    }
    else
    {
        [self funChangeRighBarButtonItemEditSave:true];
    }
    
    favouriteTintImage = [[UIImage imageNamed:@"Fav_Unselect.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveMembership)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.scrolViewMembership.contentSize = CGSizeMake(self.scrolViewMembership.frame.size.width, self.onView.frame.size.height * 13.5 + 50);
    
    [self.navigationController setToolbarHidden:false animated:true];
    
    [[AppData sharedAppData] showAddOnTopOfToolBar];
    
    [self funSetFavouriteButtonBottom];
}

-(void)funSetFavouriteButtonBottom
{
    if (self.isFavourite == true)
    {
        self.isFavourite = true;
        [self.favouriteBtn setSelected:true];
        //            [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateNormal];
        [self.favouriteBtn setImage:favouriteTintImage forState:UIControlStateNormal];
        [self.favouriteBtn setTintColor:[[AppData sharedAppData] funGetThemeColor]];
    }
    else
    {
        self.isFavourite = false;
        [self.favouriteBtn setSelected:false];
        [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isBeingDismissed] || [self isMovingFromParentViewController])
    {
        if (isSavedData == false)
        {
            NSString *filePath = [[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryMemberShip recordID:recordIDCategory];
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

    AppData *appData = [AppData sharedAppData];
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    NSString *filePath = [appData funGetCategoryRecordIDDirectory:KCategoryMemberShip recordID:recordIDCategory];
    NSArray *arrayFileCount = [appData getListOfDirectoryOfCategoryType:KCategoryMemberShip recordID:recordIDCategory];
    
    NSString *imageID = [[AppData sharedAppData] funGenerateUDID];
    
    //get full path
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageID]];
    
    
    //create directory
    [appData funCreateCategoryPhotosForRecordId:KCategoryMemberShip recordID:recordIDCategory];
    
    [pngData writeToFile:filePath atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self funUpdateCollectionPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewPhotos reloadData];
        });
    }];
    
}

-(void)viewDidLayoutSubviews
{
//    noImageYetLabel.frame = CGRectMake(0, self.collectionViewPhotos.frame.size.height/2 - 22, self.view.frame.size.width - 8, 44);
    noImageView.frame = CGRectMake(self.collectionViewPhotos.frame.size.width/2-22, self.collectionViewPhotos.frame.size.height/2 - 22, 44, 44);
}

-(void)prepareImages
{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSArray *arrayListFiles = [[AppData sharedAppData] getListOfDirectoryOfCategoryType:KCategoryMemberShip recordID:recordIDCategory];
    
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
        NSString *filePath = [[[AppData sharedAppData] funGetCategoryRecordIDDirectory:KCategoryMemberShip recordID:recordIDCategory] stringByAppendingPathComponent:fileName];
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
//        noImageYetLabel.hidden = true;
        noImageView.hidden = true;
    }
    else
    {
//        noImageYetLabel.hidden = false;
        noImageView.hidden = false;
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
    NSString *recordID = [self.ObjectMembership valueForKey:@"recordID"];
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
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategoryMemberShip recordIDToDelete:recordID];
                                  
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
    categoryVC.categoryType = KCategoryMemberShip;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}

//Horizontalscroll cell delegate method
-(void)funRemoveImage:(int)tag
{
    NSString *imageToDeletePath = [imagePathsArray objectAtIndex:tag];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:imageToDeletePath error:&error];
    NSLog(@"error deleting photo - %@",error);
    
    [self funUpdateCollectionPhotos];
    [self.collectionViewPhotos deleteItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:tag inSection:0], nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionViewPhotos reloadData];
    });
//    [self performSelector:@selector(funUpdateCollectionPhotos) withObject:nil afterDelay:0.5];
}

-(void)funUpdateCollectionPhotos
{
    [self prepareImages];
    /*dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionViewPhotos reloadData];
    });*/
    
}

#pragma mark:- keyboard notifications
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewMembership.frame = CGRectMake(_scrolViewMembership.frame.origin.x, _scrolViewMembership.frame.origin.y, _scrolViewMembership.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrolViewMembership.frame = CGRectMake(_scrolViewMembership.frame.origin.x, _scrolViewMembership.frame.origin.y, _scrolViewMembership.frame.size.width, _scrolViewMembership.frame.size.height + keyboardFrame.size.height);
}

- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}

-(void)funDoFavourite
{
    if (self.txtMemberName.text.length == 0 && self.txtMemberID.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtMemberName.layer.borderWidth = 1.0;
        self.txtMemberName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtMemberID.layer.borderWidth = 1.0;
        self.txtMemberID.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtMemberName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtMemberName.layer.borderWidth = 1.0;
        self.txtMemberName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtMemberID.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtMemberID.layer.borderWidth = 1.0;
        self.txtMemberID.layer.borderColor = [UIColor redColor].CGColor;
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
//            [self.favouriteBtn setImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateNormal];
            [self.favouriteBtn setImage:favouriteTintImage forState:UIControlStateNormal];
            [self.favouriteBtn setTintColor:[[AppData sharedAppData] funGetThemeColor]];
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
            senderFrame = _memberSinceDateButton.frame;
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
    
    NSString *stringDate = [formatter stringFromDate:pickedDate];//[NSString stringWithFormat:@"%@",pickedDate];
    
    switch (dateViewTag) {
        case 5:
            [self.expiryDateButton setTitle:stringDate forState:UIControlStateNormal];
            [self.ObjectMembership setValue:pickedDate forKey:@"expiryDate"];
            break;
        case 8:
            [self.memberSinceDateButton setTitle:stringDate forState:UIControlStateNormal];
            [self.ObjectMembership setValue:pickedDate forKey:@"memberSinceDate"];
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
    if (self.ObjectMembership != nil)
    {
        self.txtMemberPassword.secureTextEntry = true;
        
        NSString *decPass = [[AppData sharedAppData] decrypt:[self.ObjectMembership valueForKey:@"memberPassword"] withKey:[AppData sharedAppData].userAppPassword];
        
        self.txtMemberName.text = [self.ObjectMembership valueForKey:@"memberName"];
        self.txtGroupName.text = [self.ObjectMembership valueForKey:@"groupName"];
        self.txtTelephone.text = [self.ObjectMembership valueForKey:@"telephone"];
        self.txtMemberID.text = [self.ObjectMembership valueForKey:@"memberID"];
        if (decPass != nil)
        {
            self.txtMemberPassword.text = decPass;
        }
        self.txtWebsite.text = [self.ObjectMembership valueForKey:@"website"];
        //        self.txtNote.text = [self.ObjectMembership valueForKey:@"note"];
        if ([self.ObjectMembership valueForKey:@"note"] != nil)
        {
            [self.noteButton setTitle:[self.ObjectMembership valueForKey:@"note"] forState:UIControlStateNormal];
        }
        else{
            [self.noteButton setTitle:[self.ObjectMembership valueForKey:@"Tap to create note"] forState:UIControlStateNormal];
        }
        
        NSLog(@"expirydate- %@",[self.ObjectMembership valueForKey:@"expiryDate"]);
        NSLog(@"validFrom date- %@",[self.ObjectMembership valueForKey:@"memberSinceDate"]);
        
        id expiryDate = [self.ObjectMembership valueForKey:@"expiryDate"];
        if (expiryDate != nil)
        {
            [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",expiryDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
        
        id sinceDate = [self.ObjectMembership valueForKey:@"memberSinceDate"];
        if (sinceDate != nil)
        {
            [self.memberSinceDateButton setTitle:[NSString stringWithFormat:@"%@",sinceDate] forState:UIControlStateNormal];
        }
        else
        {
            [self.memberSinceDateButton setTitle:[NSString stringWithFormat:@"%@",[NSDate date]] forState:UIControlStateNormal];
        }
        
        self.isFavourite = [[self.ObjectMembership valueForKey:@"isFavourite"] boolValue];
        
        [self funSetFavouriteButtonBottom];
        
    }
    else
    {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [NSDate date];
        
        [self.expiryDateButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
        [self.memberSinceDateButton setTitle:[NSString stringWithFormat:@"%@",[formate stringFromDate:date]] forState:UIControlStateNormal];
    }
    
    if (self.ObjectMembership != nil)
    {
        recordIDCategory = [self.ObjectMembership valueForKey:@"recordID"];
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
    self.txtGroupName.userInteractionEnabled = false;
    self.txtWebsite.userInteractionEnabled = false;
    self.txtTelephone.userInteractionEnabled = false;
    self.txtMemberName.userInteractionEnabled = false;
    self.txtMemberID.userInteractionEnabled = false;
    self.txtMemberPassword.userInteractionEnabled = false;
    self.noteButton.userInteractionEnabled = false;
    self.memberSinceDateButton.userInteractionEnabled = false;
    self.expiryDateButton.userInteractionEnabled = false;
    
    self.collectionViewPhotos.userInteractionEnabled = false;
}

-(void)EditCategory
{
    self.txtGroupName.userInteractionEnabled = true;
    self.txtWebsite.userInteractionEnabled = true;
    self.txtTelephone.userInteractionEnabled = true;
    self.txtMemberName.userInteractionEnabled = true;
    self.txtMemberID.userInteractionEnabled = true;
    self.txtMemberPassword.userInteractionEnabled = true;
    self.noteButton.userInteractionEnabled = true;
    
    self.memberSinceDateButton.userInteractionEnabled = true;
    self.expiryDateButton.userInteractionEnabled = true;
    
    self.collectionViewPhotos.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

-(void)AddSaveMembership
{
    //Validation
    //1. should have to enter bankName, accountNumber
    if (self.txtMemberName.text.length == 0 && self.txtMemberID.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtMemberName.layer.borderWidth = 1.0;
        self.txtMemberName.layer.borderColor = [UIColor redColor].CGColor;
        self.txtMemberID.layer.borderWidth = 1.0;
        self.txtMemberID.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtMemberName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtMemberName.layer.borderWidth = 1.0;
        self.txtMemberName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtMemberID.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtMemberID.layer.borderWidth = 1.0;
        self.txtMemberID.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *objectKey = recordIDCategory;
    
    
    NSString *encCardPIN = [[AppData sharedAppData] encrypt:self.txtMemberPassword.text withKey:[AppData sharedAppData].userAppPassword];
    
    [object setValue:self.txtMemberName.text forKey:@"title"];
    [object setValue:self.txtMemberName.text forKey:@"memberName"];
    [object setValue:self.txtMemberID.text forKey:@"memberID"];
    
    if (encCardPIN != nil)
    {
        [object setValue:encCardPIN forKey:@"memberPassword"];
    }
    else
    {
        [object setValue:@"" forKey:@"memberPassword"];
    }
    
    [object setValue:self.txtGroupName.text forKey:@"groupName"];
    [object setValue:self.txtTelephone.text forKey:@"telephone"];
    [object setValue:self.txtWebsite.text forKey:@"website"];
    [object setValue:self.expiryDateButton.titleLabel.text forKey:@"expiryDate"];
    [object setValue:self.memberSinceDateButton.titleLabel.text forKey:@"memberSinceDate"];
    [object setValue:[NSNumber numberWithInt:7] forKey:@"categoryType"];
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
    
    [[AppData sharedAppData] funSaveCategoryData:KCategoryMemberShip objectKey:objectKey dictionary:object];
    
    isSavedData = true;
    
    //pop to list view
    [self.navigationController popViewControllerAnimated:true];
}

-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.txtMemberName.text forKey:@"title"];
    [object setValue:self.txtMemberName.text forKey:@"memberName"];
    [object setValue:self.txtMemberID.text forKey:@"memberID"];
    [object setValue:self.txtMemberPassword.text forKey:@"memberPassword"];
    [object setValue:self.txtTelephone.text forKey:@"telephone"];
    [object setValue:self.txtWebsite.text forKey:@"website"];
    [object setValue:self.expiryDateButton.titleLabel.text forKey:@"expiryDate"];
    [object setValue:self.memberSinceDateButton.titleLabel.text forKey:@"memberSinceDate"];
    //    [object setValue:self.txtNote.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:7] forKey:@"categoryType"];
    
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
    if (self.txtMemberPassword.secureTextEntry == true)
    {
        self.txtMemberPassword.secureTextEntry = false;
        [self.showHidePinBtn setTitle:@"Hide" forState:UIControlStateNormal];
    }
    else
    {
        self.txtMemberPassword.secureTextEntry = true;
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
    hsc.title.text = @"Membership Photos";
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
