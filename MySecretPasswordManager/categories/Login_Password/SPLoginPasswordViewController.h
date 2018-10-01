//
//  SPLoginPasswordViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 14/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SWRevealTableViewCell.h"

#import "LoginPasswordObject.h"

@interface SPLoginPasswordViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrolViewLoginPass;
@property (weak, nonatomic) LoginPasswordObject *loginPassObject;

@end
