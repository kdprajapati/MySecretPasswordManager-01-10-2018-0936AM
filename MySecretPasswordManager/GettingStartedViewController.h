//
//  GettingStartedViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 20/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageChildViewController.h"

@interface GettingStartedViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageChildViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getStartedBtn;

@property (strong, nonatomic) UIPageViewController *pageController;


@end
