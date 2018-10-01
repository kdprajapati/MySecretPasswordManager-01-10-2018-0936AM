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

    self.scrollViewLogin.contentSize = CGSizeMake(self.scrollViewLogin.frame.size.width, self.loginView.frame.size.height * 5);
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(AddSaveLogin)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveButton, nil];
    
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
//            [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            self.isFavourite = true;
            [self.favouriteButton setSelected:true];
//            [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateSelected];
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
    [object setValue:self.noteTxt.text forKey:@"note"];
    [object setValue:[NSNumber numberWithInt:3] forKey:@"categoryType"];
    
    return object;
    
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
        self.noteTxt.text = [self.loginObject valueForKey:@"note"];
        if (decPassword != nil)
        {
            self.passwordTxt.text = decPassword;
        }        
        self.isFavourite = [[self.loginObject valueForKey:@"isFavourite"] boolValue];
        
        if (self.isFavourite == true)
        {
            self.isFavourite = true;
            [self.favouriteButton setSelected:true];
//            [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"Fav_Selected.png"] forState:UIControlStateSelected];
            
        }
        else
        {
            self.isFavourite = false;
            [self.favouriteButton setSelected:false];
//            [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"Fav_Unselect.png"] forState:UIControlStateNormal];
        }
    }
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
        objectKey = [[CoreDataStackManager sharedManager] funGenerateUDID];
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
    [object setValue:self.noteTxt.text forKey:@"note"];
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
