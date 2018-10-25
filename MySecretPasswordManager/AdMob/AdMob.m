//
//  HelloWorldLayer.m
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//
#import "AdMob.h"
#import "Firebase.h"
#import "AppDelegate.h"
#import "protocol.h"
#import "AppData.h"
@class AppData;
@implementation AdMob
{
    AppDelegate *appdelegate;
    CGSize screenSize;
}
static AdMob *_sharedAdMob = nil;
+(AdMob *)sharedAdMob
{
    if(!_sharedAdMob)
    {
        if([ [AdMob class] isEqual:[self class]])
            _sharedAdMob = [[AdMob alloc] init];
        else
            _sharedAdMob = [[self alloc] init];
    }
    return _sharedAdMob;
}
+(id)alloc
{
    NSAssert(_sharedAdMob == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}
-(id) init
{
    if( (self=[super init]))
    {
        appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        screenSize=[[UIScreen mainScreen] bounds].size ;
        [GADMobileAds configureWithApplicationID:ADMob_AppID];
        
        [self addViewMyAppBanner];
        
    }
    return self;
}
-(void)addViewMyAppBanner
{
    if(screenSize.width==768)
    {
        self.adSize=CGSizeMake(768, 90);
    }
    else if(screenSize.width==1024)
    {
        self.adSize=CGSizeMake(1024, 90);
    }
    else if(screenSize.width==320)
    {
        self.adSize=CGSizeMake(320, 50);
    }
    else if(screenSize.width==414)
    {
        self.adSize=CGSizeMake(414, 60);
    }
    else if(screenSize.width==375)
    {
        self.adSize=CGSizeMake(375, 55);
    }
    else 
    {
        self.adSize=CGSizeMake(414, 60);
    }
    
    self.bannerView = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0,0,self.adSize.width,self.adSize.height)];
    [[appdelegate.window rootViewController].view addSubview:self.bannerView];
    self.bannerView.adUnitID =ADMob_BannerID;
    self.bannerView.delegate=self;
    self.bannerView.rootViewController = [appdelegate.window rootViewController];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID,@"49c9cf7b30e56697a0ce3fb0c69226de"];
    [self.bannerView loadRequest:request];
    self.interstitial =[self createAndLoadInterstitial];
    //[self setBannerAtBottom];
}
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    NSLog(@"AdReceived");
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"error %@",error.localizedDescription);
}
-(GADInterstitial*)createAndLoadInterstitial
{
    GADInterstitial *interstitial1 =[[GADInterstitial alloc] initWithAdUnitID:ADMob_FullScreenID];
    interstitial1.delegate=self;
    GADRequest *request1 = [GADRequest request];
    request1.testDevices = @[kGADSimulatorID, @"49c9cf7b30e56697a0ce3fb0c69226de"];
    [interstitial1 loadRequest:request1];
    return interstitial1;
}
-(void)showFullScreenAd
{
    if(![AppData sharedAppData].isRemoveAdPurchased)
    {
        if(self.interstitial.isReady)
        {
            [self.interstitial presentFromRootViewController:[appdelegate.window rootViewController]];
        }
    }
}
-(void)showFullScreenAdonComtroller:(UIViewController*)controller
{
    if(![AppData sharedAppData].isRemoveAdPurchased)
    {
        if(self.interstitial.isReady)
        {
            [self.interstitial presentFromRootViewController:controller];
        }
    }
}
-(void)hideBannerAd
{
    self.bannerView.hidden=YES;
}
-(void)ShowBannerAd
{
    if(![AppData sharedAppData].isRemoveAdPurchased)
    {
        self.bannerView.hidden=NO;
    }
}
-(void)hideAllAds
{
    self.bannerView.hidden=YES;
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    if([self.delagteForCloseEvent respondsToSelector:@selector(closeAdmobFullScreen)])
    {
        [self.delagteForCloseEvent performSelector:@selector(closeAdmobFullScreen)];
    }
    self.interstitial = [self createAndLoadInterstitial];
}
-(void)setBannerInBhajanScreen
{
    self.bannerView.frame =CGRectMake(0,screenSize.height-self.adSize.height,self.adSize.width,self.adSize.height);
}
-(void)setBannerAtBottom
{
    self.bannerView.frame =CGRectMake(0,screenSize.height-self.adSize.height,self.adSize.width,self.adSize.height);
}
-(void)setBannerAtTop
{
    if(screenSize.width==768)
    {
        self.adSize=CGSizeMake(768, 90);
    }
    else if(screenSize.width==1024)
    {
        self.adSize=CGSizeMake(1024, 90);
    }
    else if(screenSize.width==320)
    {
        self.adSize=CGSizeMake(320, 50);
    }
    else if(screenSize.width==414)
    {
        self.adSize=CGSizeMake(414, 60);
    }
    else if(screenSize.width==375)
    {
        self.adSize=CGSizeMake(375, 55);
    }
    else
    {
         self.adSize=CGSizeMake(414, 60);
    }
    self.bannerView.frame =CGRectMake(0,0,self.adSize.width,self.adSize.height);

}
@end
