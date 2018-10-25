//
//  HelloWorldLayer.h
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//
#import <StoreKit/StoreKit.h>
@protocol InAppPurchaseProtocolDelegate <NSObject>
@required
-(void)showActivityLoader;
-(void)hideActivityLoader;
-(void)inAppPurchaseDoneForID:(NSString *)strInAppItemID;
@end

@interface InAppPurchase : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
    id <InAppPurchaseProtocolDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
+(InAppPurchase *)sharedInAppPurchase;
-(void)purchaseProduct:(SKProduct*)product;
-(void)restoredInAppPurchased;
-(SKProduct *)getProductWithID:(NSString *)strID;
@end
