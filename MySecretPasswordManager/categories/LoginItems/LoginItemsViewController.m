//
//  LoginItemsViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 23/12/17.
//  Copyright © 2017 nil. All rights reserved.
//
#import "SPPreviewViewPopupController.h"
#import "LoginItemsViewController.h"
#import "CoreDataStackManager.h"
#import "AppData.h"
#import "PreviewNewViewController.h"

@interface LoginItemsViewController ()
{
    CGFloat scrollViewHeight;
}
@end

@implementation LoginItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"Login/Password";
    
    self.scrollViewLogin.contentSize = CGSizeMake(self.scrollViewLogin.frame.size.width, self.loginView.frame.size.height * 4.5);
    
    [self funAllocBottomBarButtons];
    
    [self funSetDataToViews];
    
    self.loginNameTxt.delegate = self;
    self.urlWebTxt.delegate = self;
    self.usernameTxt.delegate = self;
    self.passwordTxt.delegate = self;
    self.noteTxt.delegate = self;
    
    scrollViewHeight = _scrollViewLogin.frame.size.height;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.loginObject == nil)
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
    [self.navigationController setToolbarHidden:false animated:true];
    
    [[AppData sharedAppData] showAddOnTopOfToolBar];
}

/**
 add bottom bar buttons - favourite and settings
 */
-(void)funAllocBottomBarButtons
{
    
    UIBarButtonItem *flexibalSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.favouriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.favouriteButton setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
    [self.favouriteButton addTarget:self action:@selector(funDoFavourite) forControlEvents:UIControlEventTouchUpInside];
    self.favouriteButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIBarButtonItem *favouriteBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.favouriteButton];
    
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
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveLogin)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    }
    
}

#pragma mark:- keyboard notifications
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrollViewLogin.frame = CGRectMake(_scrollViewLogin.frame.origin.x, _scrollViewLogin.frame.origin.y, _scrollViewLogin.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _scrollViewLogin.frame = CGRectMake(_scrollViewLogin.frame.origin.x, _scrollViewLogin.frame.origin.y, _scrollViewLogin.frame.size.width, _scrollViewLogin.frame.size.height + keyboardFrame.size.height);
}
- (IBAction)funDoFavourite:(id)sender
{
    [self funDoFavourite];
}

-(void)funDoFavourite
{
    if (self.usernameTxt.text.length == 0 && self.passwordTxt.text.length == 0)
    {
        [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
        self.usernameTxt.layer.borderWidth = 1.0;
        self.usernameTxt.layer.borderColor = [UIColor redColor].CGColor;
        self.passwordTxt.layer.borderWidth = 1.0;
        self.passwordTxt.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.usernameTxt.text.length == 0)
    {
        [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
        self.usernameTxt.layer.borderWidth = 1.0;
        self.usernameTxt.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.passwordTxt.text.length == 0)
    {
        [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
        self.passwordTxt.layer.borderWidth = 1.0;
        self.passwordTxt.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    else
    {
        if (self.isFavourite == true)
        {
            self.isFavourite = false;
            [self.favouriteButton setSelected:false];
            [self.favouriteButton setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
            self.isFavourite = true;
            [self.favouriteButton setSelected:true];
            [self.favouriteButton setImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateNormal];
            
        }
        
    }
}

- (IBAction)funDeleteObject:(id)sender
{
    NSString *recordID = [self.loginObject valueForKey:@"recordID"];
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
                                  [[AppData sharedAppData] funDeleteCategoryData:KCategoryLoginPassword recordIDToDelete:recordID];
                                  
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
    categoryVC.categoryType = KCategoryLoginPassword;
    
    [self.navigationController pushViewController:categoryVC animated:true];
}
-(NSMutableDictionary *)funReturnCurrentObjectForPreview
{
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    [object setValue:self.loginNameTxt.text forKey:@"title"];
    [object setValue:self.loginNameTxt.text forKey:@"loginName"];
    [object setValue:self.urlWebTxt.text forKey:@"url"];
    [object setValue:self.usernameTxt.text forKey:@"username"];
    //    [object setValue:self.noteTxt.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:3] forKey:@"categoryType"];
    
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

- (IBAction)funShowHidePIN:(id)sender
{
    if (self.passwordTxt.secureTextEntry == true)
    {
        self.passwordTxt.secureTextEntry = false;
        [self.showHidePinBtn setTitle:@"Hide" forState:UIControlStateNormal];
    }
    else
    {
        self.passwordTxt.secureTextEntry = true;
        [self.showHidePinBtn setTitle:@"Show" forState:UIControlStateNormal];
    }
}
#pragma mark :- save / Set data methods
-(void)funSetDataToViews
{
    if (self.loginObject != nil)
    {
        NSString *decPassword = [[AppData sharedAppData] decrypt:[self.loginObject valueForKey:@"password"] withKey:[AppData sharedAppData].userAppPassword];
        
        self.loginNameTxt.text = [self.loginObject valueForKey:@"title"];
        self.urlWebTxt.text = [self.loginObject valueForKey:@"url"];
        self.usernameTxt.text = [self.loginObject valueForKey:@"username"];
        //        self.noteTxt.text = [self.loginObject valueForKey:@"note"];
        if ([self.loginObject valueForKey:@"note"] != nil)
        {
            [self.noteButton setTitle:[self.loginObject valueForKey:@"note"] forState:UIControlStateNormal];
        }
        else{
            [self.noteButton setTitle:[self.loginObject valueForKey:@"Tap to create note"] forState:UIControlStateNormal];
        }
        if (decPassword != nil)
        {
            self.passwordTxt.text = decPassword;
        }
        self.isFavourite = [[self.loginObject valueForKey:@"isFavourite"] boolValue];
        
        if (self.isFavourite == true)
        {
            self.isFavourite = true;
            [self.favouriteButton setSelected:true];
            [self.favouriteButton setImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
            self.isFavourite = false;
            [self.favouriteButton setSelected:false];
            [self.favouriteButton setImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)funSetInteractionFalseToAllTextfields
{
    self.loginNameTxt.userInteractionEnabled = false;
    self.urlWebTxt.userInteractionEnabled = false;
    self.usernameTxt.userInteractionEnabled = false;
    self.passwordTxt.userInteractionEnabled = false;
    self.noteButton.userInteractionEnabled = false;
    
}

-(void)EditCategory
{
    self.loginNameTxt.userInteractionEnabled = true;
    self.urlWebTxt.userInteractionEnabled = true;
    self.usernameTxt.userInteractionEnabled = true;
    self.passwordTxt.userInteractionEnabled = true;
    self.noteButton.userInteractionEnabled = true;
    
    [self funChangeRighBarButtonItemEditSave:false];
}

- (IBAction)copyUsername:(id)sender {
    NSString *copyStringverse = _usernameTxt.text;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
    
    [[AppData sharedAppData] showAlertWithMessage:@"\"Username\" Copied successfuly." andTitle:@"Success"];
}

-(void)AddSaveLogin
{
    
    //Validation
    if (self.usernameTxt.text.length == 0 && self.passwordTxt.text.length == 0)
    {
        [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
        self.usernameTxt.layer.borderWidth = 1.0;
        self.usernameTxt.layer.borderColor = [UIColor redColor].CGColor;
        self.passwordTxt.layer.borderWidth = 1.0;
        self.passwordTxt.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.usernameTxt.text.length == 0)
    {
        [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
        self.usernameTxt.layer.borderWidth = 1.0;
        self.usernameTxt.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    if (self.passwordTxt.text.length == 0)
    {
        [[AppData sharedAppData] showAlertWithMessage:@"Enter Required Fields." andTitle:@"Alert"];
        self.passwordTxt.layer.borderWidth = 1.0;
        self.passwordTxt.layer.borderColor = [UIColor redColor].CGColor;
        return;
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    NSString *objectKey;
    if (self.loginObject != nil)
    {
        objectKey = [self.loginObject valueForKey:@"recordID"];
    }
    else
    {
        objectKey = [[AppData sharedAppData] funGenerateUDID];
    }
    
    NSString *encPassword = [[AppData sharedAppData] encrypt:self.passwordTxt.text withKey:[AppData sharedAppData].userAppPassword];
    
    [object setValue:self.loginNameTxt.text forKey:@"title"];
    [object setValue:self.loginNameTxt.text forKey:@"loginName"];
    [object setValue:self.urlWebTxt.text forKey:@"url"];
    [object setValue:self.usernameTxt.text forKey:@"username"];
    if (encPassword != nil)
    {
        [object setValue:encPassword forKey:@"password"];
    }
    else
    {
        [object setValue:@"" forKey:@"password"];
    }
    //    [object setValue:self.noteTxt.text forKey:@"note"];
    if (![self.noteButton.titleLabel.text isEqualToString:@"Tap to create note"])
    {
        [object setValue:self.noteButton.titleLabel.text forKey:@"note"];
    }
    [object setValue:[NSNumber numberWithInt:3] forKey:@"categoryType"];
    
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
    
    [[AppData sharedAppData] funSaveCategoryData:KCategoryLoginPassword objectKey:objectKey dictionary:object];
    
    //pop to list view
    [self.navigationController popViewControllerAnimated:true];
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
