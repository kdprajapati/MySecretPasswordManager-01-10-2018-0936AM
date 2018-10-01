//
//  CategoriesViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 18/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoryCollectionViewCell.h"

@interface CategoriesViewController ()
{
    NSMutableArray *categoriesItems;
}

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    categoriesItems = [[NSMutableArray alloc] init];
    [categoriesItems addObject:@"software Licence"];
    [categoriesItems addObject:@"Wireless Router"];
    [categoriesItems addObject:@"Reward Program"];
    [categoriesItems addObject:@"Secure Note"];
    [categoriesItems addObject:@"Server"];
    [categoriesItems addObject:@"Social Security No."];
    [categoriesItems addObject:@"Wireless Router"];
    [categoriesItems addObject:@"Reward Program"];
    [categoriesItems addObject:@"Secure Note"];
    [categoriesItems addObject:@"Server"];
    [categoriesItems addObject:@"Social Security No."];
    
//    self.categoriesCollectionView.dataSource = self;
//    self.categoriesCollectionView.delegate = self;
    
    [self.categoriesCollectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CategoryCollectionViewCell" ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return categoriesItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionViewCell" forIndexPath:indexPath];
    
    cell.categoryIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"Category_%ld.png",(long)indexPath.row]];
    cell.categoryName.text = [categoriesItems objectAtIndex:indexPath.row];
    cell.categoryName.adjustsFontSizeToFitWidth = true;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width * 150)/320;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        width = ([[UIScreen mainScreen] bounds].size.width * 200)/768;
    }
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

 #pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
