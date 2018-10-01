//
//  SPPreviewViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 02/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SPPreviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textViewPreview;

@property (weak, nonatomic) NSManagedObject *previewObject;
@property (nonatomic, assign) int categoryType;

@end
