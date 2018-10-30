//
//  HorizontalScrollCell.m
//  MoviePicker
//
//  Created by Muratcan Celayir on 28.01.2015.
//  Copyright (c) 2015 Muratcan Celayir. All rights reserved.
//

#import "HorizontalScrollCell.h"


@implementation HorizontalScrollCell
{
    CGFloat cellWidth;
    CGFloat cellHeight;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    cellWidth = 250;
    cellHeight = 170;
}

-(void)setUpCellWithArray:(NSArray *)array
{
    CGFloat xbase = 10;
    CGFloat width = cellWidth;
    
    [self.scroll setScrollEnabled:YES];
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    
    for(int i = 0; i < [array count]; i++)
    {
        UIImage *image = [array objectAtIndex:i];
        UIView *custom = [self createCustomViewWithImage: image tag:i];
        [self.scroll addSubview:custom];
        [custom setFrame:CGRectMake(xbase, 7, width, 170)];
        xbase += 10 + width;
        
    }
    
    if (array.count == 0)
    {
        for (UIView *view in self.scroll.subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    [self.scroll setContentSize:CGSizeMake(xbase, self.scroll.frame.size.height)];
    
    self.scroll.delegate = self;
}

-(UIView *)createCustomViewWithImage:(UIImage *)image tag:(int)tagButton
{
    UIView *custom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, 170)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, 170)];
    imageView.tag = 1024;
    [imageView setImage:image];
    
    [custom addSubview:imageView];
    custom.tag = tagButton;
    [custom setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [custom addGestureRecognizer:singleFingerTap];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(custom.frame.size.width-21, 1, 20, 20)];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [closeButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(funRemoveImage:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.backgroundColor = [UIColor lightGrayColor];
//    closeButton.center = CGPointMake(custom.frame.size.width, 0);
    closeButton.tag = tagButton;
    closeButton.layer.cornerRadius = 10;
    closeButton.layer.masksToBounds = true;
    [custom addSubview:closeButton];
    
    return custom;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    [self containingScrollViewDidEndDragging:scrollView];
    
}

- (void)containingScrollViewDidEndDragging:(UIScrollView *)containingScrollView
{
    CGFloat minOffsetToTriggerRefresh = 25.0f;
    
    NSLog(@"%.2f",containingScrollView.contentOffset.x);
    
    NSLog(@"%.2f",self.scroll.contentSize.width);
    
    if (containingScrollView.contentOffset.x <= -50)
    {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-50 , 7, cellWidth, 150)];
        
        UIActivityIndicatorView *acc = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        acc.hidesWhenStopped = YES;
        [view addSubview:acc];
        
        [acc setFrame:CGRectMake(view.center.x - 25, view.center.y - 25, 50, 50)];
        
        [view setBackgroundColor:[UIColor clearColor]];
        
        [self.scroll addSubview:view];
        
        [acc startAnimating];
        
        [UIView animateWithDuration: 0.3
         
                              delay: 0.0
         
                            options: UIViewAnimationOptionCurveEaseOut
         
                         animations:^{
                             
                             [containingScrollView setContentInset:UIEdgeInsetsMake(0, 100, 0, 0)];
                             
                         }
                         completion:nil];
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Started");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //Do whatever you want.
                
                NSLog(@"Refreshing");
                
               [NSThread sleepForTimeInterval:3.0];
                
                NSLog(@"refresh end");
                
                [UIView animateWithDuration: 0.3
                
                                      delay: 0.0
                
                                    options: UIViewAnimationOptionCurveEaseIn
                
                                 animations:^{
                
                                     [containingScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                
                                 }
                                                completion:nil];
            });
            
        });
        
    }
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"clicked");
    
    UIView *selectedView = (UIView *)recognizer.view;
    
//    if([_cellDelegate respondsToSelector:@selector(cellSelected)])
//        [_cellDelegate cellSelected];
    UIImageView *imageView = (UIImageView *)[selectedView viewWithTag:1024];
    
    if([_cellDelegate respondsToSelector:@selector(cellSelected:)])
        [_cellDelegate cellSelected:imageView.image];
    //Do stuff here...
}

-(void)funRemoveImage:(UIButton *)sender
{
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to Delete Image?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                           actionWithTitle:@"Yes"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               if([_cellDelegate respondsToSelector:@selector(funRemoveImage:)])
                               {
//                                   UIView *deletedView = [self.scroll viewWithTag:sender.tag];
//                                   [deletedView removeFromSuperview];
                                   [_cellDelegate funRemoveImage:sender.tag];
                               }
                               
                           }];
    [alert addAction:yes];
    UIAlertAction* no = [UIAlertAction
                          actionWithTitle:@"No"
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * action){}];
    [alert addAction:no];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
    
    
}

@end
