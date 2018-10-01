//
//  ImageShowViewController.m
//  MySecretPasswordManager
//
//  Created by KrishnDip on 21/08/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "ImageShowViewController.h"

@interface ImageShowViewController ()

@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageView.image = self.imageDetail;
    
    UIImage *shareImage = [UIImage imageNamed:@"share_normal.png"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(shareImage)];
    //share_normal
    self.navigationItem.rightBarButtonItem = shareButton;
}

-(void)shareImage
{
    NSArray *activityItems = [[NSArray alloc] initWithObjects:self.imageDetail, nil];
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    shareSheet.popoverPresentationController.sourceView = self.view;
    [self presentViewController:shareSheet animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
