//
//  CategoryDetailViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 24/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"

@interface CategoryDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryDetailTableView;

@property (nonatomic, assign) int categoryType;
@end
