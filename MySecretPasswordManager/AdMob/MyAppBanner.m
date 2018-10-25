//
//  HelloWorldLayer.m
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//
#import "MyAppBanner.h"

#import "AppDelegate.h"


@implementation MyAppBanner
{
    AppDelegate *appdelegate;
    CGSize adSize;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSString *strName=nil;
        if([[UIScreen mainScreen] bounds].size.width==320 )
        {
            strName=@"ramayn-ad_iphone5.jpg";
        }
        else if([[UIScreen mainScreen] bounds].size.width==375)
        {
            strName=@"ramayn-ad_iphone6.jpg";
        }
        else if([[UIScreen mainScreen] bounds].size.width==414)
        {
            strName=@"ramayn-ad_iphone6plus.jpg";
        }
        else if([[UIScreen mainScreen] bounds].size.width==768)
        {
           strName=@"ramayn-ad_ipad.jpg";
        }
        else if([[UIScreen mainScreen] bounds].size.width==1024)
        {
           strName=@"ramayn-ad_ratina.jpg";
        }
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imageView setImage:[UIImage imageNamed:strName]];
        [self addSubview:imageView];
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *appIDRamayan=@"1177916635";
    NSString *customURL = @"MusicalRamayan://location?id=1";
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        NSString *iTunesLink = [NSString stringWithFormat:@"itms://itunes.apple.com/us/app/apple-store/id%@?mt=8",appIDRamayan];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}
@end
