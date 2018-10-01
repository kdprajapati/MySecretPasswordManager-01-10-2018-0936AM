//
//  SPPreviewViewPopupController.h
//  MySecretPasswordManager
//
//  Created by Nilesh on 5/9/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SPPreviewViewPopupController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *previewTableView;
@property (strong, nonatomic) IBOutlet UILabel *previewTitle;
@property (strong, nonatomic) NSDictionary *previewObject;
@property (nonatomic, assign) int categoryType;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end
