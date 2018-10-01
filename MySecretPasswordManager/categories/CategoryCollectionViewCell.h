//
//  CategoryCollectionViewCell.h
//  MySecretPasswordManager
//
//  Created by Dev on 19/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;

@end
