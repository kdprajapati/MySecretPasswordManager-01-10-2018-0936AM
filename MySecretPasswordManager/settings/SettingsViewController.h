//
//  SettingsViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 18/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchase.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InAppPurchaseProtocolDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
 

@end
