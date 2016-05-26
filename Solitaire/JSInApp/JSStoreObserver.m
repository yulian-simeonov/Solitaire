//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import "JSStoreObserver.h"
#import "JSStoreManager.h"

@implementation JSStoreObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [self restoreTransaction:transaction];
				break;
            default:
                break;
		}
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSString* strMessage;
    switch (transaction.error.code) {
        case SKErrorClientInvalid:
            strMessage = @"Client is not allowed to issue the request.";
            break;
        case SKErrorPaymentCancelled:
            strMessage = @"Payment was cancelled";
            break;
        case SKErrorPaymentInvalid:
            strMessage = @"Purchase identifier was invalid.";
            break;
        case SKErrorPaymentNotAllowed:
            strMessage = @"This device is not allowed to make the payment.";
            break;
        case SKErrorStoreProductNotAvailable:
            strMessage = @"Product is not available.";
            break;
        default:
            strMessage = @"Failed in-app purcahse.";
            break;
    }
    [[JSStoreManager sharedManager] Failed:strMessage];
}

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"%@", transaction.transactionDate);
    [[JSStoreManager sharedManager] SuccessfullyPurchased:transaction.payment.productIdentifier];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[JSStoreManager sharedManager] Restored:transaction.originalTransaction.payment.productIdentifier];
}

@end
