//
//  PageChildViewController.h
//  FirstTimeFlow_PasswordManager
//
//  Created by Nilesh on 4/24/18.
//  Copyright © 2018 NilApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageChildViewControllerDelegate <NSObject>

-(void)childViewAppear:(NSInteger)index;

@end

@interface PageChildViewController : UIViewController
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewHelp;
@property (strong, nonatomic) IBOutlet UILabel *titleLabelHelp;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabelHelp;

@property (nonatomic,weak) id delegate;

@end
