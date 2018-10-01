//
//  PageChildViewController.m
//  FirstTimeFlow_PasswordManager
//
//  Created by Nilesh on 4/24/18.
//  Copyright © 2018 NilApps. All rights reserved.
//

#import "PageChildViewController.h"

@interface PageChildViewController ()

@end

@implementation PageChildViewController
{
    NSArray *titleTextArray;
    NSArray *subTitleTextArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleTextArray = [[NSArray alloc] initWithObjects:@"Keep All your Credentials\nSafe at one place.",@"Secure All your Document\nDetails with Photos",@"Manage Unlimitted Account Details\nfor Free", nil];
    
    subTitleTextArray = [[NSArray alloc] initWithObjects:@"Get inside your financial life and make\neasy smart changes right away",@"You can create multiple documents\nlists details with adding photos.",@"Relax we realy secure your social\naccounts with safeguard", nil];
    
    
    self.imageViewHelp.image = [UIImage imageNamed:[NSString stringWithFormat:@"Help-%d.png",self.index]];
    NSString *titleString = [titleTextArray objectAtIndex:self.index];
    NSString *subTitleString = [subTitleTextArray objectAtIndex:self.index];
    self.titleLabelHelp.text = titleString;
    self.subTitleLabelHelp.text = subTitleString;

}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear page child");
    if (self.delegate)
    {
        [self.delegate childViewAppear:self.index];
    }
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
