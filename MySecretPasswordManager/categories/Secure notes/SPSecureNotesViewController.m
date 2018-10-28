//
//  SPSecureNotesViewController.m
//  MySecretPasswordManager
//
//  Created by ChirakJMistry on 14/04/18.
//  Copyright © 2018 nil. All rights reserved.
//
#import "SPPreviewViewPopupController.h"
#import "SPSecureNotesViewController.h"
#import "AppData.h"
#import "CoreDataStackManager.h"
#import "PreviewNewViewController.h"

@interface SPSecureNotesViewController ()
{
    CGFloat scrollViewHeight;
}

@end

@implementation SPSecureNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Secure Note";
    
    self.secureNotesScrollView.contentSize = CGSizeMake(self.secureNotesScrollView.frame.size.width, self.view.frame.size.height + 20);
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveSecureNote)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    
    [self funAllocBottomBarButtons];
    
    [self funSetDataToViews];
    
    self.txtNoteName.delegate = self;
    
    self.textViewNote.layer.cornerRadius = 4;
    self.textViewNote.layer.borderWidth = 1.0;
    self.textViewNote.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    scrollViewHeight = self.secureNotesScrollView.frame.size.height;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.noteObject == nil)
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
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveSecureNote)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.secureNotesScrollView.contentSize = CGSizeMake(self.secureNotesScrollView.frame.size.width, self.view.frame.size.height + 20);
    
    [self.navigationController setToolbarHidden:false animated:true];
    
    [[AppData sharedAppData] showAddOnTopOfToolBar];
    
}

#pragma mark:- keyboard notifications
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    self.secureNotesScrollView.frame = CGRectMake(self.secureNotesScrollView.frame.origin.x, self.secureNotesScrollView.frame.origin.y, self.secureNotesScrollView.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    self.secureNotesScrollView.frame = CGRectMake(self.secureNotesScrollView.frame.origin.x, self.secureNotesScrollView.frame.origin.y, self.secureNotesScrollView.frame.size.width, self.secureNotesScrollView.frame.size.height + keyboardFrame.size.height);
}

- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}


-(void)funDoFavourite
{
    if (self.txtNoteName.text.length == 0 && self.textViewNote.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtNoteName.layer.borderWidth = 1.0;
        self.txtNoteName.layer.borderColor = [UIColor redColor].CGColor;
        self.textViewNote.layer.borderWidth = 1.0;
        self.textViewNote.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtNoteName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtNoteName.layer.borderWidth = 1.0;
        self.txtNoteName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.textViewNote.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.textViewNote.layer.borderWidth = 1.0;
        self.textViewNote.layer.borderColor = [UIColor redColor].CGColor;
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
- (IBAction)funDeleteObject:(id)sender
{
    NSString *recordID = [self.noteObject valueForKey:@"recordID"];
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
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategorySecureNote recordIDToDelete:recordID];
                                  
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
    categoryVC.categoryType = KCategorySecureNote;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}

-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.txtNoteName.text forKey:@"title"];
    [object setValue:self.textViewNote.text forKey:@"note"];
    [object setValue:[NSNumber numberWithInt:5] forKey:@"categoryType"];
    
    return object;
    
}

#pragma mark :- save / Set data methods
-(void)funSetDataToViews
{
    if (self.noteObject != nil)
    {
        
        self.txtNoteName.text = [self.noteObject valueForKey:@"title"];
        self.textViewNote.text = [self.noteObject valueForKey:@"note"];
        
        self.isFavourite = [[self.noteObject valueForKey:@"isFavourite"] boolValue];
        
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
}

-(void)funSetInteractionFalseToAllTextfields
{
    self.txtNoteName.userInteractionEnabled = false;
    self.textViewNote.userInteractionEnabled = false;
    
}

-(void)EditCategory
{
    self.txtNoteName.userInteractionEnabled = true;
    self.textViewNote.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

-(void)AddSaveSecureNote
{
    
    //Validation
    if (self.txtNoteName.text.length == 0 && self.textViewNote.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtNoteName.layer.borderWidth = 1.0;
        self.txtNoteName.layer.borderColor = [UIColor redColor].CGColor;
        self.textViewNote.layer.borderWidth = 1.0;
        self.textViewNote.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.txtNoteName.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.txtNoteName.layer.borderWidth = 1.0;
        self.txtNoteName.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.textViewNote.text.length == 0)
    {
        [self funShowValidationAlert:1];
        self.textViewNote.layer.borderWidth = 1.0;
        self.textViewNote.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *objectKey;
    if (self.noteObject != nil)
    {
        objectKey = [self.noteObject valueForKey:@"recordID"];
    }
    else
    {
        objectKey = [[CoreDataStackManager sharedManager] funGenerateUDID];
    }
    
    
    [object setValue:self.txtNoteName.text forKey:@"title"];
    if (self.isFavourite == true)
    {
        [object setValue:[NSNumber numberWithBool:true] forKey:@"isFavourite"];
    }
    else
    {
        [object setValue:[NSNumber numberWithBool:false] forKey:@"isFavourite"];
    }
    [object setValue:self.textViewNote.text forKey:@"note"];
    [object setValue:[NSNumber numberWithInt:5] forKey:@"categoryType"];
    
    //Save plist and in memory object
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc] init];
    [saveDict setObject:object forKey:objectKey];
    
    [[AppData sharedAppData] funSaveCategoryData:KCategorySecureNote objectKey:objectKey dictionary:object];
    
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
