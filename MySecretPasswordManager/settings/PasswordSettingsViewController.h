//
//  PasswordSettingsViewController.h
//  MySecretPasswordManager
//
//  Created by Karan on 10/10/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *PasswordSettingsTableView;

@end
