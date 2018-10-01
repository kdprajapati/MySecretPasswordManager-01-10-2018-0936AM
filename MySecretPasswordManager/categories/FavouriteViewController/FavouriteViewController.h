//
//  FavouriteViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 15/03/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"

@interface FavouriteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *favouriteTableView;

@end
