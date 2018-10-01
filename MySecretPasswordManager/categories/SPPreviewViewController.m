//
//  SPPreviewViewController.m
//  MySecretPasswordManager
//
//  Created by Dev on 02/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SPPreviewViewController.h"
#import "CoreDataStackManager.h"
#import <UIKit/UIKit.h>
//#import <Photos/Photos.h>

@interface SPPreviewViewController ()

@end

@implementation SPPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *previewString = [[CoreDataStackManager sharedManager] funGetPreviewString:self.previewObject categoryType:self.categoryType];
    
    NSArray *arrStrings = [previewString componentsSeparatedByString:@"\n"];
    NSLog(@"arrStrings - %@",arrStrings);
    if (previewString != nil)
    {
        self.textViewPreview.text = previewString;
    }
    else
    {
        self.textViewPreview.text = @"Can not create Preview.";
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.textViewPreview setContentOffset:CGPointZero animated:NO];
}

- (void)viewDidLayoutSubviews {
    [self.textViewPreview setContentOffset:CGPointZero animated:NO];
}

- (IBAction)funTakeScreenShot:(id)sender {
//    [self.view snapshotViewAfterScreenUpdates:NO];
    
    // Define the dimensions of the screenshot you want to take (the entire screen in this case)
    CGSize size =  self.textViewPreview.bounds.size;//[[UIScreen mainScreen] bounds].size;
    
    // Create the screenshot
    UIGraphicsBeginImageContext(size);
    // Put everything in the current view into the screenshot
    [[self.textViewPreview layer] renderInContext:UIGraphicsGetCurrentContext()];
    // Save the current image context info into a UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    /*[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"PHAuthorizationStatusAuthorized");
            {
                // Save the screenshot to the device's photo album
//                UIImageWriteToSavedPhotosAlbum(newImage, self,
//                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
                [self funShareScreenShot:newImage];
            }
                break;
            case PHAuthorizationStatusDenied:
                NSLog(@"PHAuthorizationStatusDenied");
            {
                UIAlertController *dateAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"action Denied!!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                [dateAlert addAction:closeAction];
                
                [self presentViewController:dateAlert animated:true completion:nil];
            }
                break;
            case PHAuthorizationStatusNotDetermined:
                NSLog(@"PHAuthorizationStatusNotDetermined");
            {
                UIAlertController *dateAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"action not determined!!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                [dateAlert addAction:closeAction];
                
                [self presentViewController:dateAlert animated:true completion:nil];
            }
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"PHAuthorizationStatusRestricted");
            {
                UIAlertController *dateAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"action Restricted!!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                [dateAlert addAction:closeAction];
                
                [self presentViewController:dateAlert animated:true completion:nil];
            }
                break;
        }
    }];*/
    
    
    
}

// callback for UIImageWriteToSavedPhotosAlbum
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        // Handle if the image could not be saved to the photo album
    }
    else {
        // The save was successful and all is well
    }
}


/**
 It will open share sheet to share image of preview

 @param screenshotImage image of preview passed
 */
-(void)funShareScreenShot:(UIImage *)screenshotImage
{
    NSArray *activityItems = [NSArray arrayWithObjects:screenshotImage, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}


/**
 It will open share sheet to share text preview

 @param sender share button
 */
- (IBAction)funSharePreview:(id)sender {
    NSArray *activityItems = [NSArray arrayWithObjects:self.textViewPreview.text, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
- (IBAction)funCopyToClipboard:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.textViewPreview.text;
    NSLog(@"copied...");
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
