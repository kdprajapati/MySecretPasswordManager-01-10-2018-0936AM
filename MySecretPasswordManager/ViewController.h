//
//  ViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 05/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainMenuTableView;

@end

