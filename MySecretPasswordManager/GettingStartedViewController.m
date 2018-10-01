//
//  GettingStartedViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 20/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "GettingStartedViewController.h"
#import "MPassCodeViewController.h"
#import "MPasswordViewController.h"


@interface GettingStartedViewController ()

@end

@implementation GettingStartedViewController
{
    NSArray *titleTextArray;
    NSArray *subTitleTextArray;
    UIButton *skipDoneButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*self.welcomeLabel.text = @"Welcome To\nSecret Password Manager";
    self.getStartedBtn.layer.cornerRadius = 4.0;*/
    
    titleTextArray = [[NSArray alloc] initWithObjects:@"Add Secure Documents\nDetails with Photos",@"SafeGuard Your Social Media\nAccounts and Passwords",@"Save All Passwords\nin One Place", nil];
    
    subTitleTextArray = [[NSArray alloc] initWithObjects:@"You can create multiple documents\nlists details with adding photos.",@"Relax we realy secure your social\naccounts with safeguard",@"Get inside your financial life and make\neasy smart changes right away", nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
   
    
    PageChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //71,34,150
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
 
    
    skipDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [skipDoneButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipDoneButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [skipDoneButton addTarget:self action:@selector(funGetStarted:) forControlEvents:UIControlEventTouchUpInside];
    skipDoneButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 55, [UIScreen mainScreen].bounds.size.height - 22);
    [self.pageController.view addSubview:skipDoneButton];
    
    self.pageController.view.backgroundColor = [UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0]];
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.translucent = true;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIPageControl class]])
        {
            view.backgroundColor = [UIColor colorWithRed:81/255 green:38/255 blue:171/255 alpha:1.0];
        }
    }

}

- (IBAction)funGetStarted:(id)sender
{
    MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
    homeVc.passwordModeType = 0;
    [self presentViewController:homeVc animated:true completion:^{
        
    }];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PageChildViewController *)viewController index];
    
    if (index == 2)
    {
        [skipDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [skipDoneButton setTitle:@"Skip" forState:UIControlStateNormal];
    }
    
    if (index == 0) {
        return nil;
    }

    index--;
    
    //    pageControl.currentPage = index;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PageChildViewController *)viewController index];
    
    if (index == 2)
    {
        [skipDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [skipDoneButton setTitle:@"Skip" forState:UIControlStateNormal];
    }
    
    index++;
    
    //    pageControl.currentPage = index;
    
    
    if (index == 3) {
        return nil;
    }
    
    
    return [self viewControllerAtIndex:index];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    NSUInteger index = previousViewControllers.count - 1;
    if (index == 2)
    {
        [skipDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [skipDoneButton setTitle:@"Skip" forState:UIControlStateNormal];
    }
}

- (PageChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    PageChildViewController *childViewController = [[PageChildViewController alloc] initWithNibName:@"PageChildViewController" bundle:nil];
    childViewController.delegate = self;
    childViewController.index = index;
    
    
    return childViewController;
    
}

-(void)childViewAppear:(NSInteger)index
{
    if (index == 2)
    {
        [skipDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        [skipDoneButton setTitle:@"Skip" forState:UIControlStateNormal];
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
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
