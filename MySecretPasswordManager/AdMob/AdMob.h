//
//  HelloWorldLayer.h
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//

@class GADBannerView;
@import GoogleMobileAds;
@interface AdMob : NSObject<GADBannerViewDelegate,GADInterstitialDelegate>
{
    
}
@property (strong, nonatomic)GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic)id delagteForCloseEvent;
@property(nonatomic)SEL selectorForCloseEvent;

@property CGSize adSize;
+(AdMob *)sharedAdMob;
-(void)showFullScreenAd;
-(void)hideAllAds;
-(void)hideBannerAd;
-(void)ShowBannerAd;
-(void)setBannerAtBottom;
-(void)setBannerAtTop;
-(void)addViewMyAppBanner;
-(void)showFullScreenAdonComtroller:(UIViewController*)controller;
@end
