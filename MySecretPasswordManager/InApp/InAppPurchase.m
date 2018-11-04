//
//  HelloWorldLayer.m
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//
#import "InAppPurchase.h"
#import "protocol.h"
#import "AppData.h"
@class AppData;
@implementation InAppPurchase

static InAppPurchase *_sharedInAppPurchase = nil;
+(InAppPurchase *)sharedInAppPurchase
{
    if(!_sharedInAppPurchase)
    {
        if( [ [InAppPurchase class] isEqual:[self class]] )
            _sharedInAppPurchase = [[InAppPurchase alloc] init];
        else
            _sharedInAppPurchase = [[self alloc] init];
    }
    return _sharedInAppPurchase;
}
+(id)alloc
{
    NSAssert(_sharedInAppPurchase == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

-(id) init
{
    if( (self=[super init]) )
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [self fetchAvailableProducts];
    }
    return self;
}
-(void)fetchAvailableProducts
{
    NSSet *productIdentifiers = [NSSet setWithObjects:InAppId,nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}
-(SKProduct *)getProductWithID:(NSString *)strID
{
    for(SKProduct *product in validProducts)
    {
        if([product.productIdentifier isEqualToString:strID])
        {
            return product;
        }
    }
    return nil;
}
-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if (count>0)
    {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
    }
}
-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    
}
- (void)purchaseProduct:(SKProduct*)product
{
    if(product!=nil)
    {
        if ([SKPaymentQueue canMakePayments])
        {
            [self showActivityLoader];
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else
        {
            [[AppData sharedAppData] showAlertWithMessage:@"Purchases are disabled in your device, please enable it fron settings and try again" andTitle:@"Alert!"];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
//                                      @"Purchases are disabled in your device" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alertView show];
        }
    }
    
}
-(void)showActivityLoader
{
    if([self.delegate respondsToSelector:@selector(showActivityLoader)])
    {
        [self.delegate showActivityLoader];
        [[AppData sharedAppData] performSelector:@selector(hideActivityLoderAfterSomeTime) withObject:nil afterDelay:30.0];
    }

}
-(void)hideActivityLoader
{
    if([self.delegate respondsToSelector:@selector(hideActivityLoader)])
    {
        [self.delegate hideActivityLoader];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:[AppData sharedAppData] selector:@selector(hideActivityLoderAfterSomeTime) object:nil];
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}
-(void)restoredInAppPurchased
{
    if ([SKPaymentQueue canMakePayments])
    {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self showActivityLoader];
    }
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    if([queue.transactions count]>0)
    {
        for (SKPaymentTransaction *transaction in queue.transactions)
        {
            NSLog(@"transaction %@",transaction.payment.productIdentifier);
            
                NSString *productID = transaction.payment.productIdentifier;
                [purchasedItemIDs addObject:productID];
        }
    }
    else
    {
        [[AppData sharedAppData] showAlertWithMessage:@"You Don't Have Any Products For Restore" andTitle:@"Alert!"];
    }
    [self hideActivityLoader];
    
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStatePurchased:
                if([self.delegate respondsToSelector:@selector(inAppPurchaseDoneForID:)])
                {
                    [self.delegate inAppPurchaseDoneForID:transaction.payment.productIdentifier];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                 [self hideActivityLoader];
                break;
            case SKPaymentTransactionStateRestored:
                
                if([self.delegate respondsToSelector:@selector(inAppPurchaseDoneForID:)])
                {
                    [self.delegate inAppPurchaseDoneForID:transaction.payment.productIdentifier];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                 [self hideActivityLoader];
                break;
            case SKPaymentTransactionStateFailed:
                 [self hideActivityLoader];
                break;
            default:
                break;
        }
    }
//    [self hideActivityLoader];
}

@end
