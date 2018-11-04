//
//  ThemeViewController.m
//  MySecretPasswordManager
//
//  Created by KrishnDip on 08/10/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "ThemeViewController.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController
{
    UIImageView *checkImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.purpleButton.frame.size.width, self.purpleButton.frame.size.height)];
    [checkImage setImage:[UIImage imageNamed:@"check_White.png"]];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSInteger theme = [userdefaults integerForKey:@"AppTheme"];
    [self funUpdateThemeSelection:theme];
    
    self.purpleButton.layer.cornerRadius = 4.0;
    self.blueButton.layer.cornerRadius = 4.0;
    self.pinkButton.layer.cornerRadius = 4.0;
    self.yellowButton.layer.cornerRadius = 4.0;
    self.greenButton.layer.cornerRadius = 4.0;
    self.redButton.layer.cornerRadius = 4.0;
    
    self.title = @"Theme";
}

-(void)viewDidAppear:(BOOL)animated
{
    checkImage.frame = CGRectMake((self.purpleButton.frame.size.width / 2) - 15, (self.purpleButton.frame.size.height / 2) - 15, 30, 30);
}

- (IBAction)funSetTheme:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:98/255.0 green:0/255.0 blue:238/255.0 alpha:1.0];//98, 0, 238
            break;
        case 2:
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:54/255.0 blue:255/255.0 alpha:1.0];
            break;//(3, 54, 255)
        case 3:
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:2/255.0 blue:0/102 alpha:1.0];
            break;//255, 2, 102)
        case 4:
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0];
            break;//255, 165, 0)
        case 5:
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:72/255.0 green:206/255.0 blue:107/255.0 alpha:1.0];
            break;//72, 206, 107)
        case 6:
            self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:17/255.0 blue:52/255.0 alpha:1.0];
            break;//255, 17, 52)
        default:
            break;
    }
    
    [self funUpdateThemeSelection:button.tag];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:button.tag forKey:@"AppTheme"];
    [userdefaults synchronize];
    
}

-(void)funUpdateThemeSelection:(NSInteger) themeNumber
{
    if (checkImage != nil)
    {
        [checkImage removeFromSuperview];
    }
    CGColorRef borderColorWhite = [UIColor whiteColor].CGColor;
    CGColorRef borderColorClear = [UIColor clearColor].CGColor;
    float borderwidth = 3.0;
    
    [UIView animateWithDuration:0.7 animations:^{
        switch (themeNumber) {
            case 1:
                self.purpleButton.layer.borderColor = borderColorWhite;
                self.purpleButton.layer.borderWidth = borderwidth;
                [self.purpleButton addSubview:checkImage];
                
                self.blueButton.layer.borderColor = borderColorClear;
                self.pinkButton.layer.borderColor = borderColorClear;
                self.yellowButton.layer.borderColor = borderColorClear;
                self.greenButton.layer.borderColor = borderColorClear;
                self.redButton.layer.borderColor = borderColorClear;
                break;
            case 2:
                self.purpleButton.layer.borderColor = borderColorClear;
                self.blueButton.layer.borderColor = borderColorWhite;
                self.blueButton.layer.borderWidth = borderwidth;
                [self.blueButton addSubview:checkImage];
                
                self.pinkButton.layer.borderColor = borderColorClear;
                self.yellowButton.layer.borderColor = borderColorClear;
                self.greenButton.layer.borderColor = borderColorClear;
                self.redButton.layer.borderColor = borderColorClear;
                break;
            case 3:
                self.purpleButton.layer.borderColor = borderColorClear;
                self.blueButton.layer.borderColor = borderColorClear;
                self.pinkButton.layer.borderColor = borderColorWhite;
                self.pinkButton.layer.borderWidth = borderwidth;
                [self.pinkButton addSubview:checkImage];
                
                self.yellowButton.layer.borderColor = borderColorClear;
                self.greenButton.layer.borderColor = borderColorClear;
                self.redButton.layer.borderColor = borderColorClear;
                break;
            case 4:
                self.purpleButton.layer.borderColor = borderColorClear;
                self.blueButton.layer.borderColor = borderColorClear;
                self.pinkButton.layer.borderColor = borderColorClear;
                self.yellowButton.layer.borderColor = borderColorWhite;
                self.yellowButton.layer.borderWidth = borderwidth;
                [self.yellowButton addSubview:checkImage];
                
                self.greenButton.layer.borderColor = borderColorClear;
                self.redButton.layer.borderColor = borderColorClear;
                break;
            case 5:
                self.purpleButton.layer.borderColor = borderColorClear;
                self.blueButton.layer.borderColor = borderColorClear;
                self.pinkButton.layer.borderColor = borderColorClear;
                self.yellowButton.layer.borderColor = borderColorClear;
                self.greenButton.layer.borderColor = borderColorWhite;
                self.greenButton.layer.borderWidth = borderwidth;
                [self.greenButton addSubview:checkImage];
                
                self.redButton.layer.borderColor = borderColorClear;
                break;
            case 6:
                self.purpleButton.layer.borderColor = borderColorClear;
                self.blueButton.layer.borderColor = borderColorClear;
                self.pinkButton.layer.borderColor = borderColorClear;
                self.yellowButton.layer.borderColor = borderColorClear;
                self.greenButton.layer.borderColor = borderColorClear;
                self.redButton.layer.borderColor = borderColorWhite;
                self.redButton.layer.borderWidth = borderwidth;
                [self.redButton addSubview:checkImage];
                break;
                
            default:
                break;
        }
    }];
    
    
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
