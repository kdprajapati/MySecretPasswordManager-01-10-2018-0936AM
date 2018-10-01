//
//  PreviewNewViewController.h
//  MySecretPasswordManager
//
//  Created by Nilesh on 5/28/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewNewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *previewTableView;
@property (strong, nonatomic) IBOutlet UIButton *buttonShareNow;

@property (strong, nonatomic) NSDictionary *previewObject;
@property (nonatomic, assign) int categoryType;

@end
